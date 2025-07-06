# dotfiles


This dotfile repo tries to have a single source of truth for each all the places where I work. I work with personal/corporate apple computers and a personal linux desktop which currently runs Fedora.

The dotfiles are setup using a git repository that is tracked in ~/.cfg - the working files are in $HOME though[^1]. I few other repositories I have taken inspiration from are [^2], [^3], [^4]. 

## Setup


There are installation scripts in the bootstrap folder. However, they are very much a work in progress and are mostly there for me to keep track of what is installed.


## Some Key Features

### Development Flow

Each machine has it's own branch that it works on. However, each one also merges to/from main whenever there are updates.

### Identifying OS/Context

The shell/check_os.sh script helps define the computer owner (generally corportate or personal) and the operating system. These are saved into the shell variables `VAKD_COMP_OWNER` and `VAKD_COMP_OS`. These are key variables used throughout the scripts to conditionally make changes. Prefixing these with my intials came from [^3].




Influence:


[^1]: https://www.atlassian.com/git/tutorials/dotfiles
[^2]: https://github.com/FelixKratz/dotfiles/tree/master
[^3]: https://github.com/davidosomething/dotfiles
[^4]: https://github.com/BreadOnPenguins/dots

