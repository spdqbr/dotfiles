#!/bin/bash

  if ! which git;
  then
    if which yum;
    then
      sudo yum install -y git
    fi
  fi

  git config --global core.fileMode false
  git config --global user.name daniel1.hayes
  git config --global user.email daniel1.hayes@dish.com
  git config --global credential.helper "cache --timeout=28800"

