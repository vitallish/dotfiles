config.load_autoconfig()

config.bind(',p', 'open https://ccny-proxy1.libr.ccny.cuny.edu/login?qurl={url:pretty}')
config.bind(',f', 'spawn --detach firefox --new-window "{url}"')

## How to open links in an existing instance if a new one is launched.
## This happens when e.g. opening a link from a terminal. See
## `new_instance_open_target_window` to customize in which window the
## link is opened in.
## Type: String
## Valid values:
##   - tab: Open a new tab in the existing window and activate the window.
##   - tab-bg: Open a new background tab in the existing window and activate the window.
##   - tab-silent: Open a new tab in the existing window without activating the window.
##   - tab-bg-silent: Open a new background tab in the existing window without activating the window.
##   - window: Open in a new window.
##   - private-window: Open in a new private window.
c.new_instance_open_target = 'tab'

## Which window to choose when opening links as new tabs. When
## `new_instance_open_target` is set to `window`, this is ignored.
## Type: String
## Valid values:
##   - first-opened: Open new tabs in the first (oldest) opened window.
##   - last-opened: Open new tabs in the last (newest) opened window.
##   - last-focused: Open new tabs in the most recently focused window.
##   - last-visible: Open new tabs in the most recently visible window.
c.new_instance_open_target_window = 'last-focused'


c.url.searchengines = {
    'DEFAULT':  'https://kagi.com/search?q={}',
    'g':       'https://google.com/search?hl=en&q={}',
    'a':       'https://www.amazon.com/s?k={}',
    'd':       'https://duckduckgo.com/?ia=web&q={}',
    'gh':      'https://github.com/search?o=desc&q={}&s=stars',
    'gi':      'https://www.google.com/search?tbm=isch&q={}&tbs=imgo:1',
    'm':       'https://www.google.com/maps/search/{}',
    'w':       'https://en.wikipedia.org/wiki/{}',
    'yelp':    'https://www.yelp.com/search?find_desc={}',
    'yt':      'https://www.youtube.com/results?search_query={}'
}
