#!/bin/bash

title="umang's rice setup script"

downloadDependencies() {
    if grep "Arch\|Artix\|EndeavourOS\|Manjaro" /etc/*-release; then
        clear 
        echo "[*] Running an system update..."
        sudo pacman --noconfirm -Syu

        mkdir -p $HOME/.setup-scripto
        sleep 0.5
        clear

        if [[ -e /usr/bin/paru ]]; then
            echo -e "[*] paru detected. Installing dependencies..."
            paru -S bspwm sxhkd rofi polybar neovim-nightly-bin alacritty dunst picom-ibhagwan-git brightnessctl playerctl dunst hsetroot maim viewnior jq xclip bsp-layout
        elif [[ -e /usr/bin/yay ]]; then
            echo -e "[*] yay detected. Installing dependencies..."
            yay -S bspwm sxhkd rofi polybar neovim-nightly-bin alacritty dunst picom-ibhagwan-git brightnessctl playerctl dunst hsetroot maim viewnior jq xclip bsp-layout
        else
            # Line from https://github.com/Axarva/dotfiles-2.0/blob/9f0a71d7b23e1213383885f2ec641da48eb01681/install-on-arch.sh#L67
            read -r -p "Would you like to install yay? [Y/n]: " yay
            sleep 1.5

            case $yay in
                [yY][*])
                    git clone https://aur.archlinux.org/yay.git $HOME/.setup-scripto
                    (cd $HOME/.setup-scripto && makepkg -si)

                    echo "[*] yay installed. Installing dependencies..."
                    yay -S bspwm sxhkd rofi polybar neovim-nightly-bin alacritty picom brightnessctl playerctl dunst hsetroot maim viewnior jq xclip bsp-layout
                    ;;
                [nN])
                    echo "[*] Okay. Will not install yay."
                    ;;
            esac 
        fi

        sleep 1
    else
        clear
        echo "[*] Not on a Arch based system. Failed to download dependencies. Please manually install it."

        sleep 1
    fi
}

copyFiles() {
    clear
    
    sleep 1
    echo "[*] Copying files..."
    echo "[*] Will make backups if there are configurations found."

    if [[ -d $HOME/.config/alacritty ]]; then
        mkdir $HOME/.config/alacritty.bak && mv $HOME/.config/alacritty/* $HOME/.config/alacritty.bak
        cp -r ./cfg/alacritty/* $HOME/.config/alacritty/
    else
        mkdir $HOME/.config/alacritty && cp -r ./cfg/alacritty/* $HOME/.config/alacritty
    fi

    if [[ -d $HOME/.config/bspwm ]]; then
        mkdir $HOME/.config/bspwm.bak && mv $HOME/.config/bspwm/* $HOME/.config/bspwm.bak
        cp -r ./cfg/bspwm/* $HOME/.config/bspwm/
    else
        mkdir $HOME/.config/bspwm && cp -r ./cfg/bspwm/* $HOME/.config/bspwm
    fi

    if [[ -d $HOME/.config/dunst ]]; then
        mkdir $HOME/.config/dunst.bak && mv $HOME/.config/dunst/* $HOME/.config/dunst.bak
        cp -r ./cfg/dunst/* $HOME/.config/dunst/
    else
        mkdir $HOME/.config/dunst && cp -r ./cfg/dunst/* $HOME/.config/dunst
    fi

    if [[ -d $HOME/.config/eww ]]; then
        mkdir $HOME/.config/eww.bak && mv $HOME/.config/eww/* $HOME/.config/eww.bak
        cp -r ./cfg/eww/* $HOME/.config/eww/
    else
        mkdir $HOME/.config/eww && cp -r ./cfg/eww/* $HOME/.config/eww
    fi

    if [[ -d $HOME/.config/nvim ]]; then
        mkdir $HOME/.config/nvim.bak && mv $HOME/.config/nvim/* $HOME/.config/nvim.bak
        cp -r ./cfg/nvim/* $HOME/.config/nvim/
    else
        mkdir $HOME/.config/nvim && cp -r ./cfg/nvim/* $HOME/.config/nvim
    fi

    if [[ -d $HOME/.config/picom ]]; then
        mkdir $HOME/.config/picom.bak && mv $HOME/.config/picom/* $HOME/.config/picom.bak
        cp -r ./cfg/picom/* $HOME/.config/picom/
    else
        mkdir $HOME/.config/picom && cp -r ./cfg/picom/* $HOME/.config/picom
    fi

    if [[ -d $HOME/.config/polybar ]]; then
        mkdir $HOME/.config/polybar.bak && mv $HOME/.config/polybar/* $HOME/.config/polybar.bak
        cp -r ./cfg/polybar/* $HOME/.config/polybar/
    else
        mkdir $HOME/.config/polybar && cp -r ./cfg/polybar/* $HOME/.config/polybar
    fi

    if [[ -d $HOME/.config/starship ]]; then
        mkdir $HOME/.config/starship.bak && mv $HOME/.config/starship/* $HOME/.config/starship.bak
        cp -r ./cfg/starship/* $HOME/.config/starship/
    else
        mkdir $HOME/.config/starship && cp -r ./cfg/starship/* $HOME/.config/starship
    fi

    if [[ -d $HOME/.config/sxhkd ]]; then
        mkdir $HOME/.config/sxhkd.bak && mv $HOME/.config/sxhkd/* $HOME/.config/sxhkd.bak
        cp -r ./cfg/sxhkd/* $HOME/.config/sxhkd/
    else
        mkdir $HOME/.config/sxhkd && cp -r ./cfg/sxhkd/* $HOME/.config/sxhkd
    fi

    if [[ -d $HOME/.config/rofi ]]; then
        mkdir $HOME/.config/rofi.bak && mv $HOME/.config/rofi/* $HOME/.config/rofi.bak
        cp -r ./cfg/rofi/* $HOME/.config/rofi/
    else
        mkdir $HOME/.config/rofi && cp -r ./cfg/rofi/* $HOME/.config/rofi
    fi

    if [[ -d $HOME/.local/bin ]]; then
        cp -r ./bin/* $HOME/.local/bin
    else
        mkdir $HOME/.local/bin && cp -r ./bin/* $HOME/.local/bin
    fi

    if [ -d $HOME/.local/share/fonts ]; then
        cp -r ./etc/fonts/* $HOME/.local/share/fonts
    else
        mkdir $HOME/.local/share/fonts && cp -r ./etc/fonts/* $HOME/.local/share/fonts
    fi

    if [ -d $HOME/Pictures/Wallpapers ]; then
        cp -r ./etc/walls/Stars.png $HOME/Pictures/Wallpapers 
    else 
        mkdir $HOME/Pictures/Wallpapers && cp -r ./etc/walls/gruv.png $HOME/Pictures/Wallpapers
    fi

    sleep 1
    echo "[*] Copied files successfully."
    sleep 1
}

finalizeChanges() {
    clear
    echo "[*] Refreshing font cache..."
    fc-cache -v

    clear
    sleep 1

    clear
    echo "[*] Finalizing changes..."
    sleep 3
    clear
}

fuckUser() {
    clear
    echo "[*] An error occured. Exiting."
    exit
}

welcome() {
    whiptail --title "$title" \
        --no-button "Exit" --yes-button "Continue" \
        --yesno "This process will download the needed dependencies and copy the config files to $HOME/.config. Would you like to continue?" 10 70
}

success() {
    # Remove the custom directory made by the script
    rm -rf $HOME/.setup-scripto

    whiptail --title "$title" \
        --msgbox "Setup success. Please restart BSPWM if you are on an active session. Check notes on the repository's README." 20 50
}

echo "[*] Starting setup script..."
sleep 1

# Prompt user the welcome dialog
welcome || fuckUser

# Download dependencies
downloadDependencies

# Copy files from the repo to $HOME/.config
copyFiles

# Restart everything lol
finalizeChanges

# Show the success dialog when everything is fine
success && clear
