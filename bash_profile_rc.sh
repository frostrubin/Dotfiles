# When you start an interactive shell (log in, open new Terminal Tab in OS X)
# the following files are read and run, in this order:
#     profile
#     bashrc
#     .bash_profile
#     .bashrc (only if you source the file in .bash_profile)
#
# When an interactive shell, that is not a login shell, is started 
# (when you run "bash" from inside a shell) the order is as follows:
#     bashrc
#     .bashrc
#
# I am using this by having two symlinks for .bashrc and .bash_profile
# point to the same file

#### Do not show the line with the last login
touch ~/.hushlogin

#### Setup some colors
export COLOR_NC='\033[0m' # No Color
export COLOR_BLUE='\033[0;34m'
export COLOR_GREEN='\033[0;32m'
export COLOR_RED='\033[0;31m'

#### Generic BASH Settings ####
export EDITOR=nano

### Check directories and add existing to $PATH
  for dir in \
          ~/Scripts \
          ~/.functions \
#          /usr/bin \  # This commented entry is important
	  do
	  [ -d "${dir}" ] && PATH="${PATH}:${dir}"
  done

# Source special git functions
source ~/.git-prompt.sh

### Basic bash settings  
export HISTCONTROL=erasedups          # Erase duplicates
export HISTSIZE=5000                  # Big history
export HISTFILESIZE=5000              # Big history
shopt -s histappend                   # Append history continuously
#export HISTIGNORE="ls:cd:[bf]g:exit" # Ignore ls, cd, exit, etc
export HISTCONTROL="ignoreboth"       # Ignore duplicate lines or lines starting with a space
bind 'set match-hidden-files off'     # Hidden files are only recommended on .[tab][tag], not [tab][tab]
#bind "set completion-ignore-case on" # Ignore case on completion  
bind "set show-all-if-ambiguous On"   # Show list automatically, without double tab
bind "set bell-style none"            # No bell
shopt -s checkwinsize                 # Check window size after each command


### Generic System independent Functions ###
function octal () { # ls with permissions in octal form
   ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf("%0o ",k);print}'
}

function cd () { # Far superior cd. cd ........ is possible
   local -ri n=${#*};
   if [ $n -eq 0 -o -d "${!n}" -o "${!n}" == "-" ]; then
      builtin cd "$@";
   else
      local e="s:\.\.\.:../..:g";
      builtin cd "${@:1:$n-1}" $(sed -e$e -e$e -e$e <<< "${!n}");
   fi
}

function encrypt () {
  openssl aes-256-cbc -a -in "$1" -out "$1".aes256cbc  
}

function decrypt () {
  openssl aes-256-cbc -d -a -in "$1" -out "${1%.aes256cbc}"  
}

function man2pdf () {
  [[ $(man "$1") ]] || return;
  man -t "$1"|open -f -a Preview
}

function create () {   # Easier script creation
  [[ "$#" -eq 0 ]] && return;
  touch "$1"
  chmod +x "$1"
  if [ "${1#*.}" == "sh" ];then
    echo -e "#!/usr/bin/env bash\n" >> "$1"
  elif [ "${1#*.}" == "html" ];then
    echo -e '<html>\n<head>\n<style type="text/css">\n\n</style>\n</head>\n<body>\n\n</body>\n</html>' >> "$1"
  fi
  open "$1"
}

function fillGitIgnore() {
  echo -ne "*.DS_Store\n*.swp\n*.privatei" > ~/.gitignore
}

function cleanup() { # Remove unwanted files from current folder
  find . -name "*.sfv" -exec rm -rf {} \;
  find . -name "*.nfo" -exec rm -rf {} \;
  find . -type d -name "Sample" -exec rm -rf {} \;
  find . -name "Thumbs.db" -exec rm -rf {} \;
  find . -name "filename.txt" -exec rm -rf {} \;
}

# Prompt with current git branch
  # The \[ and \] brackets around the colors are very important!
  # Not for the actual color display (it works without them) but for the terminal.app
  # to know that colors are being printed.
  # Otherwise, Terminal navigation (ctrl+a, ctrl+e) does not work properly!
  long_prompt='$(status=$?;
  echo -ne "\[${COLOR_BLUE}\]";
  __git_ps1 "%s ";
  echo -ne "\[${COLOR_NC}\]";
  if [[ $status = 0 ]]; then 
    echo -ne "\[${COLOR_GREEN}\]:)"; 
  else 
    echo -ne "\[${COLOR_RED}\]:("; 
  fi;
  echo -ne "\[${COLOR_NC}\]";)'

  PS1="\W $long_prompt "

  # Together with shopt histappend, this makes the bash history available
  export PROMPT_COMMAND="history -a; history -c; history -r"

### Mac Specific Functions ###
function hidehomedirs () {
  mv -f ~/Pictures/iPod\ Photo\ Cache ~/.Trash/iPodPhotoCache`date "+%Y%m%d%H%M%S"`/ > /dev/null 2>&1
  for i in $(ls ~);do
    var=$(find  ~/"$i" -maxdepth 1 -not -name .localized -not -name .DS_Store -not -name iChats -not -name .com.apple.timemachine.supported|tail -n +2)

    if [ "$var" == "" ] || 
       [ "$i" == "Library" ] || 
       [ "$i" == "Desktop" ] || 
       [ "$i" == "Music" ] || 
       [ "$i" == "Public" ];then
      chflags hidden ~/"$i"
    else
      chflags nohidden ~/"$i"
    fi
  done
}

function activateCmdClick() {
  ps x|grep 'CmdClic[k]' > /dev/null 2>&1
  [[ $? -ne 0 ]] && $(CmdClick > /dev/null 2>&1 &)
}

function topng () {
  [ "$#" -eq 0 ] && echo "You have to specify at least 1 file";
  for var in "$@"; do 
    FILENAME=`echo ${var##*/}`;
    EXT=`echo ${var##*.}`
    NOEXT=`echo ${FILENAME%\.*}`
    sips -s format png "$var" --out "$NOEXT".png
    sips -i "$NOEXT".png
  done
}

### Mac Specific Aliases
alias ls='ls -G'      # color the ls output
alias ll='ls -GFlash' # shortcut for detailed listing
alias less='less -IR' # better less
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias my="my_helpers.sh"

### General Aliases
alias cds="cd;hidehomedirs;activateCmdClick;clear;ls;" # Go home an clear screen
alias grep='grep --color=auto' # colored grep
alias ducks='du -cksh *'       # folders and files sizes in current folder
alias untar="tar xvzf"         # untar
alias top='top -o cpu'         # Sort top by CPU
alias m2='man2pdf'             # Shortcut for manpages
alias pyserv='python -m SimpleHTTPServer 8080'
