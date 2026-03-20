# Instructions to install WIFI drivers

When running Fedora on a Mac, for example an old Intel Macbook Pro, WIFI drivers are not included in the base installation. In order to enable WIFI, the `broadcom-wl` driver needs to be installed.

1. Identify the Broadcom device:
    ```
    lspci -nn | grep -i broadcom
    ```
    Confirm that you see the Broadcom chipset, e.g. BCM453xx, BCM43142 etc.

2. Enable RPM Fusion repositories, because `broadcom-wl` is in the nonfree repository.
    ```
    sudo dnf install \
      https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
      https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
    ```

3. Update package metadata
    ```
    sudo dnf upgrade --refresh
    ```

4. Install build tools and kernel headers
    ```
    sudo dnf install akmods "kernel-devel-uname-r == $(uname -r)"
    sudo dnf install @development-tools
    ```

5. Install the driver package
    ```
    sudo dnf install broadcom-wl
    ```

6. Build the kernel module
    ```
    sudo akmods --force
    ```

7. Reboot
    ```
    sudo reboot
    ```
