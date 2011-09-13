# Generic ------------------------------------------

export EDITOR=nano

# PATH
# Check directories and add existing to $PATH
  for dir in \
          ~/Scripts \
          ~/.functions/ \
          ~/.functions/mupdf05 \
          ~/.functions/ImageMagick-6.6.4/bin \
#          /usr/bin \
	  do
	  [ -d "${dir}" ] && PATH="${PATH}:${dir}"
  done


# Basic bash settings
  # Erase duplicates
  export HISTCONTROL=erasedups 
  # Big history
  export HISTSIZE=5000
  export HISTFILESIZE=5000
  # Append history instead of overwriting on close
  shopt -s histappend
  # Ignore ls, cd, exit, etc.
  #export HISTIGNORE="ls:cd:[bf]g:exit"  
  # Ignore lines that begin with a space character and duplicate lines
  export HISTCONTROL="ignoreboth"   
  # if you cd [tab][tab], no hidden files will be recommended. Only if you cd .[tab][tab]
  bind 'set match-hidden-files off' 
  # note: bind used instead of sticking these in .inputrc
  #bind "set completion-ignore-case on" 
  # show list automatically, without double tab
  bind "set show-all-if-ambiguous On" 
  # no bell
  bind "set bell-style none"
  # After each command, checks the windows size and changes lines and columns
  shopt -s checkwinsize 

# Create a small gollum server
#gollum --port 43879 --host 127.0.0.1 /pub/Scripts/command_wiki/ > /dev/null 2>&1 &

# Functions
hf(){ 
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

function hidehomedirs () {
  for i in $(ls ~);do
    var=`find  ~/"$i" -maxdepth 1 -not -name .localized -not -name .DS_Store|wc -l`
    var="${var#"${var%%[![:space:]]*}"}"
    var="${var%"${var##*[![:space:]]}"}"
    
    if [ $var -eq 1 ] || [ "$i" == "Library" ];then
      chflags hidden ~/"$i"
    else
      chflags nohidden ~/"$i"
    fi
  done
}

# And run it directly
hidehomedirs

function parse_git_branch {
  currentbranch=`git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
  if [ ${#currentbranch} -gt 0 ];then
    echo -ne "$currentbranch "
  fi
}


# Aliases
  alias cds="cd;clear;ls;"
  # colored grep
  alias grep='grep --color=auto'
  # Very simple stopwatch funtionality
  alias stopwatch='echo "Terminal is in stopwatch mode. Hit ctrl+C to stop tracking the time."; time cat'
  # Lists folders and files sizes in the current folder
  alias ducks='du -cksh *' 
  # Shows most used commands, 
  #cool script I got this from: http://lifehacker.com/software/how-to/turbocharge-your-terminal-274317.php
  alias profileme="history | awk '{print \$2}' | awk 'BEGIN{FS=\"|\"}{print \$1}' | sort | uniq -c | sort -n | tail -n 20 | sort -nr"
  # Untar
  alias untar="tar xvzf"
  #copies folder and all sub files and folders, preserving security and dates
  alias cp_folder="cp -Rpv" 
  

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


# OS X Specific ------------------------------------

# Functions
#function man2pdfnew () { # Output man as pdf
#   if [ ! $(echo $(man -w "$1" 2>&1) | grep -c "No manual entry for") -ge "1" ]; then
#  	   groff -mandoc `man -w $1`|open -f -a Preview
#   else
#	   echo "No manual entry for" "$1"
#   fi
#}

function create () {   # Easier script creation
   if [ "$1" == "" ]; then
     echo "Please supply a filename"
   else
     touch $1
     chmod +x $1
     if [ "${1#*.}" == "sh" ];then
       echo "#!/bin/bash" >> $1
     elif [ "${1#*.}" == "html" ] || [ "${1#*.}" == "htm" ];then
       echo -e '<html>\n<head>\n<style type="text/css">\n\n</style>\n</head>\n<body>\n\n</body>\n</html>' >> $1
     fi
     open "$1"
   fi
}

function openon () {   # Show open files on a Volume, that prevent it form umount
   lsof +D "$1" 2>/dev/null
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


# Aliases
# color the ls output
alias ls='ls -G'
# shortcut for detailed listing
alias ll='ls -GFlash'
# better less
alias less='less -IR'
# The Tree Command for Mac
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
# Short Alias for the function defined above
#alias m2='man2pdfnew'
# Sort top by CPU
alias top='top -o cpu'