# Backup and restore configuration

## GNOME

To backup the GNOME configuration, use

```
cd ~/.dotfiles && \
  ./gnome_config.sh backup && \
  git add config/dconf*.config && \
  git commit -m "GNOME configuration backup $(date +"%Y-%m-%d %H:%M:%S")" && \
  git push && \
  cd -
``` 

To restore the configuration, use:

```
cd ~/.dotfiles && \
  ./gnome_config.sh reestore && \
  cd -
```

The `awk` filter skips read-only system keys (e.g. `/system/locale`) that `dconf load` cannot write.
