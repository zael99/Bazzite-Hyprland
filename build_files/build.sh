#!/bin/bash

set -ouex pipefail

installAstal() {(
    # Install Astal
    dnf install -y \
        meson \
        vala \
        valadoc \
        gobject-introspection-devel \
        wayland-protocols-devel \
        gtk3-devel gtk-layer-shell-devel \
        gtk4-devel gtk4-layer-shell-devel

    git clone https://github.com/aylur/astal.git ~/temp

    # Build Astal
    cd ~/temp/lib/astal/io
    meson setup build
    meson install -C build

    cd ~/temp/lib/astal/gtk3
    meson setup build
    meson install -C build

    cd ~/temp/lib/astal/gtk4
    meson setup build
    meson install -C build

    #Cleanup Astal Build
    cd ~
    rm -rf temp
)}

installAGS() {(
    installAstal

    dnf install -y \
        meson ninja golang gobject-introspection-devel \
        gtk3-devel gtk-layer-shell-devel \
        gtk4-devel gtk4-layer-shell-devel

    git clone --recurse-submodules https://github.com/aylur/ags ~/temp

    # Build AGS
    cd ~/temp
    meson setup build
    meson install -C build

    #Cleanup AGS Build
    cd ~
    rm -rf temp
)}

installHyprland() {(
    # Add Hyprland COPR
    dnf copr enable solopasha/hyprland

    # Install Dependencies
    dnf install -y \
        hyprland \
        hypridle \
        waybar \
        wofi \
        swwww \
        swaync \
        stow
)}

installStarship() {(
    dnf install -y \
        fish \
        kitty

    curl -sS https://starship.rs/install.sh | sh

    # Add starship to fish
    echo "" >> ~/.bashrc
    echo "starship init fish | source" >> ~/.bashrc
)}

### Install packages
dnf5 install -y tmux 

installAGS

installHyprland
installStarship

systemctl enable podman.socket
