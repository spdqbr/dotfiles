#!/bin/bash

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

# If we're in xterm, set up color aliases
if [[ "$TERM" == "xterm" ]] || [[ "$TERM" == "cygwin" ]]
then
    COLOR_BLACK="\[\e[30m\]"
    COLOR_RED="\[\e[31m\]"
    COLOR_GREEN="\[\e[32m\]"
    COLOR_YELLOW="\[\e[33m\]"
    COLOR_BLUE="\[\e[34m\]"
    COLOR_MAGENTA="\[\e[35m\]"
    COLOR_CYAN="\[\e[36m\]"
    COLOR_WHITE="\[\e[37m\]"

    COLOR_RESET="\[\e[0m\]"
    COLOR_BRIGHT="\[\e[1m\]"
    COLOR_DIM="\[\e[2m\]"
    COLOR_UNDERSCORE="\[\e[4m\]"
    COLOR_BLINK="\[\e[5m\]"
    COLOR_REVERSE="\[\e[6m\]"
    COLOR_HIDDEN="\[\e[7m\]"

    COLOR_BG_BLACK="\[\e[40m\]"
    COLOR_BG_RED="\[\e[41m\]"
    COLOR_BG_GREEN="\[\e[42m\]"
    COLOR_BG_YELLOW="\[\e[43m\]"
    COLOR_BG_BLUE="\[\e[44m\]"
    COLOR_BG_MAGENTA="\[\e[45m\]"
    COLOR_BG_CYAN="\[\e[46m\]"
    COLOR_BG_WHITE="\[\e[47m\]"
    

    TIME_12H="\T"
    TIME_12A="\@"
    TIME_24="\t"
    PATH_SHORT="\w"
    PATH_LONG="\W"
    NEW_LINE="\n"
    JOBS="\j"
    USER="\u"
    HOST="\h"
    HISTORY_NUMBER="\!"

    # Determine host color for prompt
    if [[ $(hostname) =~ ^t ]]
    then
        COLOR_HOST="${COLOR_YELLOW}"
    elif [[ $(hostname) =~ ^p ]]
    then
        COLOR_HOST="${COLOR_RED}"
    else
        COLOR_HOST="${COLOR_BRIGHT}${COLOR_BLUE}"
    fi  

    # Command prompt smiley face on success, scared face on failure
    export PS1="${NEW_LINE}\
\$(\
if [[ \$? -eq 0 ]]; \
then \
    echo \"${COLOR_BRIGHT}${COLOR_GREEN}^_^${COLOR_RESET}\"; \
else
    echo \"${COLOR_RED}O.o\"; \
fi \
)"
    
    # Command prompt
    # user@host timestamp pwd
    export PS1="${PS1}${COLOR_GREEN}${USER}${COLOR_RED}@${COLOR_HOST}${HOST} ${COLOR_BRIGHT}${COLOR_BLACK}${TIME_24}${COLOR_RESET}${COLOR_YELLOW} ${PATH_SHORT} ${NEW_LINE}"

    # Command prompt git status if in git repo directory
    if [[ -f "${source_dir}/git-prompt.sh" ]]
    then
        source "${source_dir}/git-prompt.sh"

        export PS1="${PS1}\
\$(\
git branch &> /dev/null; \
if [[ \$? -eq 0 ]]; \
then \
    git status | grep \"nothing to commit\" > /dev/null 2>&1; \
    if [[ \$? -eq 0 ]]; \
    then \
        echo \"${COLOR_BRIGHT}${COLOR_BLUE}\$(__git_ps1 '(%s)')${COLOR_RESET} \"
    else \
        echo \"${COLOR_RED}\$(__git_ps1 '(%s)')${COLOR_RESET} \"
    fi
fi\
)"

    fi

    # Command prompt
    # Command_number $_
    export PS1="${PS1}${COLOR_YELLOW}${HISTORY_NUMBER} \$${COLOR_RESET} "

    # set xterm title while commands are running
    if [[ "$SHELL" == "/bin/bash" ]]
    then
        # trap changes to the BASH_COMMAND variable
        trap 'echo -ne "\e]0;$BASH_COMMAND\007"' DEBUG
        
        # Set the title to the pwd when no command is running
        export PS1="\[\e]0;\]${USER}@${HOST}:${PATH_SHORT}\007$PS1"
    fi
fi

# History setup
export HISTTIMEFORMAT='%F %T '       # Add timestamp to history
export HISTIGNORE="&:ls:ll:lsd:lsf:ltr:[bf]g:exit:clear:cls:history" 
                                     # Prevent common things from cluttering history
export HISTIGNORE="$HISTIGNORE:[ ]*" # Prefix command with a space to exclude from history
export HISTCONTROL="erasedups:ignoreboth"         # no duplicate entries
export HISTSIZE=100000               # big big history
shopt -s histappend                  # append to history, don't overwrite it
shopt -s histverify                  # load the history command on prompt rather than executing

# Save and reload the history after each command finishes (allows common history across several terminals)
export PROMPT_COMMAND="history -a; history -n"

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

