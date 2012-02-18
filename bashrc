#### Generic BASH Setting ####

export EDITOR=nano

### Check directories and add existing to $PATH
  for dir in \
          ~/Scripts \
          ~/.functions/ \
          ~/.functions/mupdf05 \
          ~/.functions/ImageMagick-6.6.4/bin \
#          /usr/bin \
	  do
	  [ -d "${dir}" ] && PATH="${PATH}:${dir}"
  done


### Basic bash settings  
export HISTCONTROL=erasedups          # Erase duplicates
export HISTSIZE=5000                  # Big history
export HISTFILESIZE=5000              # Big history
shopt -s histappend                   # Append history continuously
#export HISTIGNORE="ls:cd:[bf]g:exit" # Ignore ls, cd, exit, etc
export HISTCONTROL="ignoreboth"       # ignore duplicate lines or lines
                                      # or lines starting with a space
bind 'set match-hidden-files off'     # if you cd [tab][tab], no hidden
                                      # files will be recommended.
                                      # Only if you cd .[tab][tab]
#bind "set completion-ignore-case on" # Ignore case on completion  
bind "set show-all-if-ambiguous On"   # show list automatically, without
                                      # double tab
bind "set bell-style none"            # no bell
shopt -s checkwinsize                 # Check window size after each command

# Create a small gollum server
#gollum --port 43879 --host 127.0.0.1 /pub/Scripts/command_wiki/ > /dev/null 2>&1 &

### Generic System independent Functions ###
hf(){ # Search history. Very! Useful!
  grep "$@" ~/.bash_history
}

function octal () {   # ls with permissions in octal from
   ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf("%0o ",k);print}'
}

function pythonserver() {
  python -m SimpleHTTPServer 8080
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

function pdfcleandir () {
   SAVEIFS=$IFS
   IFS=$(echo -en "\n\b")
   for i in `ls ./*.pdf`;do
      echo Versuche "$i" zu entsichern
      pdfclean "$i" ${i%\.*}_entsichert.pdf
      if [ "$1" == "-d" ];then
         echo Versuche Original zu lšschen
         rm -f "$i"
      fi
   done
   IFS=$SAVEIFS
}

function man2pdfnew () { # Output man as pdf
  if [ ! $(echo $(man -w "$1" 2>&1) | grep -c "No manual entry for") -ge "1" ]; then
    cat `man -w $1`|gunzip|groff -mandoc|open -f -a Preview
  else
    echo "No manual entry for" "$1"
  fi
}

function create () {   # Easier script creation
  if [ "$1" == "" ]; then
    echo "Please supply a filename"
  else
    touch $1
    chmod +x $1
    if [ "${1#*.}" == "sh" ];then
      echo -e "#!/bin/bash" >> $1
    elif [ "${1#*.}" == "html" ] || [ "${1#*.}" == "htm" ];then
      echo -e '<html>\n<head>\n<style type="text/css">\n\n</style>\n</head>\n<body>\n\n</body>\n</html>' >> $1
    fi
    open "$1"
  fi
}

function openon () {   # Show open files on a Volume, that prevent it form umount
  lsof +D "$1" 2>/dev/null
}

function ppdirs () { # Copy Folder Structure from external drive
  if [ -d /Volumes/GoFlex/zerone ]; then
    echo "Creating ppdirlist"
    rsync -a -f"+ */" -f"- *" /Volumes/GoFlex ~/Desktop/ppdirs/
  else
    echo "Doing nothing"
  fi
}

tips(){ # Selection of bash tips to make it easier to remember them
\less  <<END
Completion:
~<tab><tab>  # User names
@<tab><tab>  # Hosts (think ssh)
$<tab><tab>  # Variables

Edit Control:
Ctrl-a       # Move to the start of the line.
Ctrl-e       # Move to the end of the line.
Ctrl-u       # Delete from the cursor to the beginning of the line.
Ctrl-k       # Delete from the cursor to the end of the line.
Ctrl-y       # Pastes text from the clipboard.
Ctrl-l       # Clear the screen leaving the current line at the top of the screen.
Ctrl-_       # Undo the last changes.
Alt-r        # Undo all changes to the line.

!!           # Execute last command in history
!abc         # Execute last command in history beginning with abc
!abc:p       # Print last command in history beginning with abc
!n           # Execute nth command in history
!$           # Last argument of last command
!^           # First argument of last command
^abc^xyz     # Replace first occurance of abc with xyz in last command and execute it

And bash has a built in 'help', type 'help' for a listing commands and 'help cmd' for help
on a paticular command.
END
}


function parse_git_branch {
  currentbranch=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ${#currentbranch} -gt 0 ];then
    echo -ne "$currentbranch "
  fi
}


# Prompt with current git branch
  # The \[ and \] brackets around the colors are very important!
  # Not for the actual color display (it works without them) but for the terminal.app
  # to know that colors are being printed.
  # Otherwise, Terminal navigation (ctrl+a, ctrl+e) does not work properly!
  long_prompt='$(status=$?;
  echo -ne "\[${COLOR_BLUE}\]";
  parse_git_branch;
  echo -ne "\[${COLOR_NC}\]";
  if [[ $status = 0 ]]; then 
    echo -ne "\[${COLOR_GREEN}\]:)"; 
  else 
    echo -ne "\[${COLOR_RED}\]:("; 
  fi;
  echo -ne "\[${COLOR_NC}\]";)'

  PS1="\W $long_prompt "

  # Together with shopt histappend, this makes the bash history available
  export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"


### Mac Specific Functions ###
function removeipodphotocache () {
  mkdir ~/Pictures/iPod\ Photo\ Cache > /dev/null 2>&1
  var=`find ~/Pictures/iPod\ Photo\ Cache/ -not -name .DS_Store|wc -l`
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"  

  if [ $var -eq 1 ];then
    rmdir ~/Pictures/iPod\ Photo\ Cache/
  fi
}

function hidehomedirs () {
  for i in $(ls ~);do
    var=`find  ~/"$i" -maxdepth 1 -not -name .localized -not -name .DS_Store -not -name iChats|wc -l`
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"

    if [ $var -eq 1 ] || [ "$i" == "Library" ];then
      chflags hidden ~/"$i"
    else
      chflags nohidden ~/"$i"
    fi
  done
}

function hidepublicfolder () {
  var=`find ~/Public/Drop\ Box/ -not -name .localized -not -name .DS_Store|wc -l`
  var="${var#"${var%%[![:space:]]*}"}"
  var="${var%"${var##*[![:space:]]}"}"
  if [ $var -eq 1 ];then
    var=`find ~/Public -not -name .localized -not -name .DS_Store -not -name .com.apple.timemachine.supported|wc -l`
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    if [ $var -eq 2 ];then
      chflags hidden ~/Public/
    fi
  fi
}

# And run it directly
removeipodphotocache
hidehomedirs
hidepublicfolder

### Mac Specific Aliases
alias ls='ls -G'      # color the ls output
alias ll='ls -GFlash' # shortcut for detailed listing
alias less='less -IR' # better less
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"


### General Aliases
alias cds="cd;clear;ls;"       # Go home an clear screen
alias grep='grep --color=auto' # colored grep
alias ducks='du -cksh *'       # folders and files sizes in current folder
alias untar="tar xvzf"         # untar
alias cp_folder="cp -Rpv"      # cp -R, preserving security and dates
alias top='top -o cpu'         # Sort top by CPU
alias m2='man2pdfnew'          # Shortcut for manpages
alias ostype='echo ${OSTYPE//[0-9.]/}' #Platform Name

