#!/bin/bash

export EDITOR=nano                                                                                                                  
# set the promt
PS1='\u@\h \W `test $? -eq 0 && echo "\[\e[0;32m:)\e[0m\]" || echo "\[\e[0;31m:(\e[0m\]" ` \[\e[0;33m⚡\e[0m\] '

stty columns 170   # Together with the functions below, this sets the terminal width and truncates long lines.
function ...() {
   local -i n;
   let n=$(tput cols)/2-3;
   sed -re "s/^(.{$n}).*(.{$n})$/\1 ... \2/"
}

# Basic bash settings
export HISTCONTROL=erasedups         # Erase duplicates
export HISTSIZE=10000                # Big history
shopt -s histappend                  # Append history instead of overwriting on close
#export HISTIGNORE="ls:cd:[bf]g:exit" # Ignore ls, cd, exit, etc. 
export HISTCONTROL="ignoreboth"      # Ignore lines which begin with a space character and duplicate lines
bind 'set match-hidden-files off'    # if you cd [tab][tab], no hidden files will be recommended. Only if you cd .[tab][tab]

alias cds="cd;clear;ls;"

# Check directories and add existing to $PATH
  for dir in \
          ~/Scripts \
          ~/.functions/ \
          ~/.functions/mupdf05 \
#          /usr/bin \
	  do
	  [ -d "${dir}" ] && PATH="${PATH}:${dir}"
  done


function octal () {   # ls with permissions in octal from
   ls -l | awk '{k=0;for(i=0;i<=8;i++)k+=((substr($1,i+2,1)~/[rwx]/)*2^(8-i));if(k)printf("%0o ",k);print}'
}

function cd () {
   local -ri n=${#*};
   if [ $n -eq 0 -o -d "${!n}" -o "${!n}" == "-" ]; then
      builtin cd "$@";
   else
      local e="s:\.\.\.:../..:g";
      builtin cd "${@:1:$n-1}" $(sed -e$e -e$e -e$e <<< "${!n}");
   fi
}

function man2pdfnew () {
   if [ ! $(echo $(man -w "$1" 2>&1) | grep -c "No manual entry for") -ge "1" ]; then
  	   man -t $* | ps2pdf - - 2>&1| open -g -f -a preview
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
       echo "#!/bin/bash" >> $1
       open -a "Xcode" $1
     elif [ "${1#*.}" == "html" ] || [ "${1#*.}" == "htm" ];then
       echo -e '<html>\n<head>\n<style type="text/css">\n\n</style>\n</head>\n<body>\n\n</body>\n</html>' >> $1
       open -a "Xcode" $1
     fi
   fi
}

function pdfcleandir () {
   SAVEIFS=$IFS
   IFS=$(echo -en "\n\b")
   for i in `ls ./*.pdf`;do
      echo Versuche "$i" zu entsichern
      pdfclean "$i" ${i%\.*}_entsichert.pdf
      if [ "$1" == "-d" ];then
         echo Versuche Original zu löschen
         rm -f "$i"
      fi
   done
   IFS=$SAVEIFS
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

keyboard(){ # Selection of keyboard shortcuts to make it easier to remember them
    \less  <<END
ScreenShots:
⌘ ⇧ 3        # Whole Screen
⌘ ⇧ 4        # Selection
⌘ ⇧ 4 + ␣    # Specific Window  

Keyboard Navigation:
⌃ F1         # Keyboard Navigation On/Off
⌃ F2         # Select Menubar (left)
⌃ F3         # Select Dock
⌃ F8         # Select Menubar (right)
⌘ ⇥          # Next application
⌘ ⇧ ⇥        # Previous application
⌘ ⇧ .        # In open/save dialogs: show hidden files 

Exposé:
If all windows of one application are displayed,
   ⇥ brings you to the next application.
END
}

# color the ls output
alias ls='ls -G'
# shortcut for detailed listing
alias ll='ls -GFlash'
# better less
alias less='less -IR'
# colored grep
alias grep='grep --color=auto'
# The Tree Command for Mac
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
# Short Alias for the function defined above
alias m2='man2pdfnew'
# Very simple stopwatch funtionality
alias stopwatch='echo "Terminal is in stopwatch mode. Hit ctrl+C to stop tracking the time."; time cat'


# show a greeter on startup
myname=`uname -sr`
if [ ${#myname} -gt 18 ]
then
        myname=`uname -sr | cut -c 1-17`'..'
fi
 
# Initial Display
echo '> '`uptime`
echo '> '$myname
echo " "