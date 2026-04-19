#!/usr/bin/env python3

# -*- coding: utf-8 -*-
#
# Based on:
# Timewarrior extension: catreport
# Author: Frank Stollmeier
# License: MIT

import os
import re
import sys

# Use virtual environment if VAKD_VENVS is set
if 'VAKD_VENVS' in os.environ:
    venv_path = os.path.join(os.environ['VAKD_VENVS'], 'timewarrior-report', 'lib', 'python3.13', 'site-packages')
    if os.path.exists(venv_path):
        sys.path.insert(0, venv_path)
from timewreport.parser import TimeWarriorParser

# Projects to drill down into (show individual tasks as a third level)
DRILLDOWN_PROJECTS = {'wes.gates-dac-review'}


class Node(dict):
    '''This node represents a task or a category of tasks and may contain other nodes.'''
    
    def __init__(self, name, parent):
        '''
        Parameters
        ----------
        name:   string
        parent: instance of Node()
        '''
        self.intervals = []
        self.name = name
        self.parent = parent
        dict.__init__(self)
    
    def get_node(self, path_to_node, create_if_not_existing = False):
        '''Return a node which is somewhere deeper in the hierarchy. 
        If the specified node does not exist return None. If create_if_not_existing is True and the specified node does not exist, create the node and return the new node.
        
        Parameters
        ----------
        path_to_node:           list of strings, e. g. ["projectA", "subprojectA1", "task13"]
        create_if_not_existing: bool, optional, default is False.
        '''
        if len(path_to_node) == 0:
            return self
        else:
            child = path_to_node.pop(0)
            if child in self:
                return self[child].get_node(path_to_node, create_if_not_existing)
            elif create_if_not_existing:
                self[child] = Node(child, self)
                return self[child].get_node(path_to_node, create_if_not_existing)
            else:
                return None
    
    def add_node(self, path_to_node):
        '''Add a new node and return it.
        
        Parameters
        ----------
        path_to_node:   list of strings, e. g. ["projectA", "subprojectA1", "task13"]
        '''
        return self.get_node(path_to_node, create_if_not_existing = True)
    
    def is_leaf(self):
        '''Return True, if the node has no child nodes, and False, if it has child nodes.'''
        return len(self) == 0
    
    def get_duration(self):
        '''Return the total number of seconds spend in this task/category excluding time spend in subcategories.'''
        return sum([i.get_duration().total_seconds() for i in self.intervals])
    
    def get_cumulated_duration(self):
        '''Return the total number of seconds spend in this task/category including the spend in subcategories.'''
        return self.get_duration() + sum([child.get_cumulated_duration() for child in self.values()])


def store_intervals_in_tree(intervals):
    '''Create and return a tree structure containing all tracked time intervals.

    Parameters
    ----------
    intervals:  list of intervals, as returned by TimeWarriorParser(stdin).get_intervals()
    '''
    root = Node('root', None)
    for interval in intervals:
        tags = list(interval.get_tags())
        task_tags = [t for t in tags if '.' not in t]
        for tag in tags:
            path = tag.split('.')
            if tag in DRILLDOWN_PROJECTS and task_tags:
                for task_tag in task_tags:
                    task_node = root.add_node(path + [task_tag])
                    task_node.intervals.append(interval)
            else:
                node = root.add_node(path)
                node.intervals.append(interval)
    return root


def print_report(root):
    '''Create the catreport.
    
    Parameters
    ----------
    root:   instance of class Node, as returned by store_intervals_in_tree()
    '''
    #tabular layout
    width_col1 = 35
    width_col2 = 10
    width_col3 = 10
    #print header
    print("{0:<{wc1}}{1:>{wc2}}{2:>{wc3}}".format('Task', 'Time [h]', 'Share [%]', wc1 = width_col1, wc2 = width_col2, wc3 = width_col3))
    print((width_col1+width_col2+width_col3)*"=")
    #print data
    def print_recursively(node, level=0, parent_path=''):
        current_path = (parent_path + '.' + node.name).lstrip('.') if node.parent is not None else ''

        hours = node.get_cumulated_duration()/(60*60)
        if level == 0:
            # root node seems to be double counting for some reason
            hours = hours/2
        if node.parent is None:
            share = 100
        else:
            parent_hours = node.parent.get_cumulated_duration()/(60*60)
            share = 100 * hours / parent_hours if parent_hours > 0 else 0

        if level == 0:
            shift = ''
        else:
            shift = (level - 1) * '  '

        # only go down the tree if it's part of the wes project
        if level == 1 and (node.name != 'wes' and node.name != 'vial'):
            return None

        # Format task names at the drilldown level (children of a drilldown project)
        display_name = node.name
        if parent_path in DRILLDOWN_PROJECTS:
            display_name = re.sub(r'^\d+:\s*', '', display_name)
            display_name = display_name[:20]

        print("{0:<{wc1}}{1:>{wc2}}{2:>{wc3}}".format(shift + display_name, "{:.1f}".format(hours), "{:.1f}".format(share), wc1=width_col1, wc2=width_col2, wc3=width_col3))

        if level == 0:
            print("\n")

        for key in sorted(node.keys()):
            print_recursively(node[key], level + 1, current_path)
        if node.get_duration() > 0 and len(node) > 0:
            h = node.get_duration()/(60*60)
            s = 100 * h / hours if hours > 0 else 0
            shift2 = (level + 1) * '    '
            print("{0:<{wc1}}{1:<{wc2}}{2:<{wc3}}".format(shift2 + 'unknown', shift2 + "{:.1f}".format(h), shift2 + "{:.1f}".format(s), wc1=width_col1, wc2=width_col2, wc3=width_col3))
    
    print_recursively(root)
    print("\n")

    
def main(stdin):
    parser = TimeWarriorParser(stdin)
    tw_config = parser.get_config()
    tw_intervals = parser.get_intervals()
    
    root = store_intervals_in_tree(tw_intervals)
    print_report(root)
    #sys.exit(0)


if __name__ == "__main__":
    main(sys.stdin)
    #print(stdin.read())


######################################################################
##    The following code is just for development and debugging.     ##
######################################################################


def load_testdata(filename):
    '''This function allows testing functions with a static data set instead of the real data from timewarrior.
    To create a static data set from your real data, comment main(sys.stdin) and uncomment print(stdin.read()) in if __name__ == "__main__", and then run timew catreport > static-data
    '''
    with open(filename, "r") as f:
        parser = TimeWarriorParser(f)
    tw_config = parser.get_config()
    tw_intervals = parser.get_intervals()
    return tw_config.get_dict(), tw_intervals    

def test():
    config,intervals = load_testdata("./static-data")
    root = store_intervals_in_tree(intervals)
    print_report(root)

def show_intervals_with(keyword, intervals):
    '''Filter intervals by key.'''
    for i in intervals:
        if keyword in i.get_tags():
            print(i.get_date(),i.get_tags())

