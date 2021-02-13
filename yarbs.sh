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
    sudo apt install \
        git \
        vim \
        tmux \
        mutt \
        newsboat \
        lynx \
        docker \
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
        -y

    pip3 install PyOpenSSL yubikey-manager
    
    git clone https://github.com/preservim/nerdtree.git ~/.vim/pack/vendor/start/nerdtree
    git clone https://github.com/yokomizor/dotfiles.git ~/.yokomizor_dotfiles

    vim -u NONE -c "helptags ~/.vim/pack/vendor/start/nerdtree/doc" -c q

    ln -s ~/.yokomizor_dotfiles/.gitconfig ~/.gitconfig
    ln -s ~/.yokomizor_dotfiles/.mailcap ~/.mailcap
    ln -s ~/.yokomizor_dotfiles/.mutt ~/.mutt
    ln -s ~/.yokomizor_dotfiles/.newsboat ~/.newsboat
    ln -s ~/.yokomizor_dotfiles/.profile ~/.profile
    ln -s ~/.yokomizor_dotfiles/.tmux.conf ~/.tmux.conf
    ln -s ~/.yokomizor_dotfiles/.vimrc ~/.vimrc

    source ~/.profile
}

start_services()
{
    sudo service pcscd start
}

welcome_message
