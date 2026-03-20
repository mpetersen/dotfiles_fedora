# Backup and restore configuration

## GNOME

To backup the GNOME configuration, use

```
cd ~/.dotfiles && \
  dconf dump / > config/gnome_config.txt && \
  git add config/gnome_config.txt && \
  git commit -m "GNOME configuration backup $(date +"%Y-%m-%d %H:%M:%S")" && \
  git push && \
  cd -
``` 

To restore the configuration, use:

```
awk '/^\[system\// { skip=1 } /^\[/ && !/^\[system\// { skip=0 } !skip' ~/.dotfiles/config/gnome_config.txt | dconf load /
```

The `awk` filter skips read-only system keys (e.g. `/system/locale`) that `dconf load` cannot write.
