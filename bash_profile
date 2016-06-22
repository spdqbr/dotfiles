#!/bin/bash

# source the users bashrc if it exists
if [[ -f "${HOME}/.bashrc" ]] ; then
    source "${HOME}/.bashrc"
fi

if [[ -f "##source_dir##/bashrc" ]]
then
    source "##source_dir##/bashrc"
fi
