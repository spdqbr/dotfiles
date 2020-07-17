#!/bin/bash

  if ! which git;
  then
    if which yum;
    then
      sudo yum install -y git
    fi
  fi

  git config --global core.fileMode false
  git config --global user.name spdqbr
  git config --global user.email spdqbr@gmail.com
  git config --global credential.helper "cache --timeout=28800"

