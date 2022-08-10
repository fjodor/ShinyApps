# From ?reactlogShow {shiny} (not package "reactlog"!)

# Set up the reactive log visualizer

options(shiny.reactlog = TRUE)

# then start app as usual

# At any time you can hit Ctrl + F3 (Mac: Command + F3) to launch reactive log visualization in browser

reactlogShow(time = TRUE)
