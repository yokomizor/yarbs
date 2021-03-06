#!/bin/sh
set -e

welcome_message()
{
    cat << EOF
================================================================================

Welcome to YARBS

================================================================================

This script will install packages in you system.

You can find the source code and more information at:
https://github.com/yokomizor/yarbs

WARNING: This script will create dotfiles in your \$HOME directory. If any the
files yarbs tries to create already exists, it will just replace.

Would you like to proceed? (root privileges will be required) [y/N]
EOF

read  answer
case $answer in
    yes|Yes|y|Y)
        install
        start_services
        ;;
    *)
        ;;
esac
}

install()
{
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0 
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key 8D81803C0EBFCD88

    sudo apt-add-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-add-repository https://cli.github.com/packages

    sudo apt update && sudo apt install \
        git \
        vim \
        tmux \
        mutt \
        newsboat \
        lynx \
        docker \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common \
        wget \
        gnupg2 \
        gnupg-agent \
        dirmngr \
        cryptsetup \
        scdaemon \
        pcscd \
        secure-delete \
        hopenpgp-tools \
        yubikey-personalization \
        libssl-dev \
        swig \
        libpcsclite-dev \
        python3-pip \
        python3-pyscard \
        xclip \
        docker-ce \
        docker-ce-cli \
        containerd.io \
        gh \
        -y

    pip3 install PyOpenSSL yubikey-manager
    
    if [ ! -d "$HOME/.vim/pack/vendor/start/nerdtree" ]; then
        git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
        vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q
    fi

    if [ ! -d "$HOME/.yokomizor_dotfiles" ]; then
        git clone https://github.com/yokomizor/dotfiles.git ~/.yokomizor_dotfiles
    fi

    ln -sf ~/.yokomizor_dotfiles/.gitconfig ~
    ln -sf ~/.yokomizor_dotfiles/.mailcap ~
    ln -sf ~/.yokomizor_dotfiles/.mutt ~
    ln -sf ~/.yokomizor_dotfiles/.newsboat ~
    ln -sf ~/.yokomizor_dotfiles/.profile ~
    ln -sf ~/.yokomizor_dotfiles/.aliases ~
    ln -sf ~/.yokomizor_dotfiles/.tmux.conf ~
    ln -sf ~/.yokomizor_dotfiles/.vimrc ~
    ln -sf ~/.yokomizor_dotfiles/.gnupg/gpg.conf ~/.gnupg/gpg.conf
    ln -sf ~/.yokomizor_dotfiles/.gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf

    setxkbmap \
        -model "pc105" \
        -layout "us" \
        -variant "intl" \
        -option "ctrl:swapcaps"

    sudo su root -c "cat > /etc/default/keyboard<< EOF
# KEYBOARD CONFIGURATION FILE

# Consult the keyboard(5) manual page.

XKBMODEL=\"pc105\"
XKBLAYOUT=\"us\"
XKBVARIANT=\"intl\"
XKBOPTIONS=\"ctrl:swapcaps\"

BACKSPACE=\"guess\"
EOF"
}

start_services()
{
    sudo service pcscd start
}

welcome_message
