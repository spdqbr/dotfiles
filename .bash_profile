#!/bin/bash

# source the users bashrc if it exists
if [[ -f "${HOME}/.bashrc" ]] ; then
    source "${HOME}/.bashrc"
fi

if [[ -f "${HOME}/dotfiles/.bashrc" ]]
then
    source "${HOME}/dotfiles/.bashrc"
fi
