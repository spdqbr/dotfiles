#!/bin/bash

# Don't source again if already sourced
if [[ "$SPDQBR_DOTFILES" == "1" ]]; then
  return
else
  export SPDQBR_DOTFILES=1
fi

source_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# List of files to look for and source at the end
sourceFiles=()

# Tricky output redirection to prevent subshell creation
# when piping to while loop so $sourceFiles stays in scope
while read -r -d $'\0' file
do
  sourceFiles+=("$file")
done < <(find "$source_dir" -type f -iname \*.source -print0)

# Set Paths
export CLASSPATH=$CLASSPATH\

# Make it easier to swap IFS with new line
export IFS_DEFAULT=$IFS
export IFS_NEW_LINE=$( echo -en "\b\n" )

# App specific variables
export SVN_EDITOR=vi
export CC=gcc
export CXX=g++
export EDITOR=vi

# Press Alt-h to read the man page of the first command on the current line
bind -x '"\eh":
        FIRST_WORD=${READLINE_LINE%% *}
        if (( READLINE_POINT > ${#FIRST_WORD} )); then
                LOOKUP_CMD=${READLINE_LINE::$READLINE_POINT} #grab the string up to the cursor. e.g. "df {} | less" where {} is the cursor looks up df.
                LOOKUP_CMD=${LOOKUP_CMD##*[;|&]} #remove previous commands from the left
                LOOKUP_CMD=${LOOKUP_CMD# } #remove leading space if it exists (only a single one though)
                LOOKUP_CMD=${LOOKUP_CMD%% *} #remove arguments to the current command from the right
        else
                LOOKUP_CMD=$FIRST_WORD #if the cursor is at the beginning of the line, look up the first word
        fi
        man "$LOOKUP_CMD"'

# History setup
export HISTTIMEFORMAT='%F %T '       # Add timestamp to history
export HISTIGNORE="&:ls:ll:lsd:lsf:ltr:[bf]g:exit:clear:cls:history" 
                                     # Prevent common things from cluttering history
export HISTIGNORE="$HISTIGNORE:[ ]*" # Prefix command with a space to exclude from history
export HISTCONTROL="erasedups:ignoreboth"         # no duplicate entries
export HISTSIZE=100000               # big big history
shopt -s histappend                  # append to history, don't overwrite it
shopt -s histverify                  # load the history command on prompt rather than executing

shopt -s autocd     # cd by typing the folder name only
shopt -s direxpand  # ./[TAB] becomes $(pwd)
shopt -s globstar   # ls -l ** recursively lists directories
shopt -s extglob    # extended globbing ?(a*|b*) a* or b*, !(a*|b*) NOT a* nor b*, *+@ == *+? regex

# allow case-insensitive globbing
shopt -s nocaseglob

# auto complete settings
bind "set completion-ignore-case on"

# treat hyphens and underscores the for complete purposes
bind "set completion-map-case on" 

# Source the files at the top
for file in "${sourceFiles[@]}"
do
    if [[ -f "$file" ]]
    then
        source "$file"
    fi
done

# enable vi style editing on command line
set -o vi