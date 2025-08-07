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

    git clone https://github.com/aylur/astal.git /tmp/astal

    # Build Astal
    cd /tmp/astal/lib/astal/io
    meson setup build
    meson install -C build

    cd /tmp/astal/lib/astal/gtk3
    meson setup build
    meson install -C build

    cd /tmp/astal/lib/astal/gtk4
    meson setup build
    meson install -C build

    #Cleanup Astal Build
    rm -rf /tmp/*
)}

installAGS() {(
    installAstal

    dnf install -y \
        meson ninja golang gobject-introspection-devel \
        gtk3-devel gtk-layer-shell-devel \
        gtk4-devel gtk4-layer-shell-devel

    git clone --recurse-submodules https://github.com/aylur/ags /tmp/ags

    # Build AGS
    cd /tmp/ags
    meson setup build
    meson install -C build

    #Cleanup AGS Build
    rm -rf /tmp/*
)}

installHyprland() {(
    # Add Hyprland COPR
    dnf copr -y enable solopasha/hyprland

    # Install Hyprland and Dependencies
    dnf install -y \
        hyprland \
        hypridle \
        waybar \
        swww \
        wofi \
        swaync \
        stow
)}

installStarship() {(
    mkdir -p /tmp/starship
    curl -sS "https://starship.rs/install.sh" > /tmp/starship/install.sh
    chmod +x /tmp/starship/install.sh
    /tmp/starship/install.sh --yes --bin-dir=/usr/bin
)}

setupTerminal() {(
    # Install Dependencies
    dnf install -y \
        zsh \
        fish \
        kitty

    installStarship
)}

cleanupTmp() {(
    rm -rf /tmp/*
)}

### Install packages
dnf5 install -y tmux 

# installAGS

installHyprland
setupTerminal
cleanupTmp

systemctl enable podman.socket
