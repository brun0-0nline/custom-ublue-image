#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Install dnf5 if not installed
if ! rpm -q dnf5 >/dev/null; then
    rpm-ostree install dnf5 dnf5-plugins
fi

# this installs a package from fedora repos
dnf5 remove -y firefox firefox-langpacks

dnf5 install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
				https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm 
				
dnf5 config-manager setopt fedora-cisco-openh264.enabled=1

dnf5 swap -y ffmpeg-free ffmpeg --allowerasing

dnf5 install -y kvantum \
				distrobox

#dnf5 install -y libva-intel-driver
#dnf5 config-manager addrepo --from-repofile=https://repo.vivaldi.com/archive/vivaldi-fedora.repo
#dnf5 install -y --assumeyes vivaldi-stable

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Example for enabling a System Unit File

systemctl enable podman.socket
