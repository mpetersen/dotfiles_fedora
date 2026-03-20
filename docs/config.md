# Backup and restore configuration

## GNOME

To backup the GNOME configuration, use

```
dconf dump / > ~/.dotfiles/config/gnome_config.txt
``` 

To restore the configuration, use:

``` 
dconf load / < ~/.dotfiles/config/gnome_config.txt
```
