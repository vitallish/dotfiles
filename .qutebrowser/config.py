config.load_autoconfig()

config.bind(',p', 'open https://ccny-proxy1.libr.ccny.cuny.edu/login?qurl={url:pretty}')
config.bind(',f', 'spawn --detach firefox --new-window "{url}"')

