# When you open new Terminal Tab in OS X
# the following files are read and run, in this order:
#     profile
#     bashrc
#     .bash_profile
#     .bashrc (only if you source the file in .bash_profile)
#
# When you run "bash" from inside a shell, the order is:
#     bashrc
#     .bashrc

touch ~/.hushlogin # Do not show the line with the last login

### Check directories and add existing to $PATH
for dir in ~/Unix ~/gsutil ;do
  [ -d "${dir}" ] && PATH="${PATH}:${dir}"
done

### Basic bash settings
export EDITOR=nano
export HISTCONTROL=erasedups          # Erase duplicates
export HISTSIZE=5000                  # Big history
shopt -s histappend                   # Append history continuously
#export HISTIGNORE="ls:cd:[bf]g:exit" # Ignore ls, cd, exit, etc
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

function man2pdf () {
  [[ $(man "$1") ]] || return; man -t "$1"|open -f -a Preview
}

function create () {
  [[ "$#" -eq 0 ]] && return;
  touch "$1"; chmod +x "$1"
  if [ "${1#*.}" == "sh" ];then
    echo -e "#!/usr/bin/env bash\n" >> "$1"
  elif [ "${1#*.}" == "html" ];then
    echo -e '<html>\n<head>\n<style type="text/css">\n\n</style>\n</head>\n<body>\n\n</body>\n</html>' >> "$1"
  fi
  open "$1"
}

function cleanup() { # Remove unwanted files from current folder
  find . -name "*.sfv" -exec rm -rf {} \;
  find . -name "*.nfo" -exec rm -rf {} \;
  find . -type d -name "Sample" -exec rm -rf {} \;
  find . -name "Thumbs.db" -exec rm -rf {} \;
  find . -name "filename.txt" -exec rm -rf {} \;
}

# The \[ and \] brackets around the colors are needed to signal the Terminal.app
# that colors are being printed. Without them, color display still works but
# Terminal navigation (ctrl+a, ctrl+e) is broken.
long_prompt='$([[ $? = 0 ]] && echo -ne "\[\033[0;32m\]:)" || echo -ne "\[\033[0;31m\]:("; echo -ne "\[\033[0m\]";)'

PS1="\W $long_prompt "
# Together with shopt histappend, this makes the bash history available
export PROMPT_COMMAND="history -a; history -c; history -r"

### Mac Specific Functions ###
function hidehomedirs () {
  for i in $(ls ~);do
    var=$(find  ~/"$i" -maxdepth 1 ! -name .localized ! -name .DS_Store ! -name .com.apple.timemachine.supported \
          ! -name .parallels-vm-directory|tail -n +2)

    if [ "$var" == "" ]          || 
       [ "$i" == "Library" ]     || 
       [ "$i" == "Desktop" ]     || 
       [ "$i" == "Music" ]       || 
       [ "$i" == "gsutil" ]      ||
       [ "$i" == "Windows.pvm" ] ||
       [ "$i" == "bin" ]         ||
       [ "$i" == "Public" ]; then
      chflags hidden ~/"$i"
    else
      chflags nohidden ~/"$i"
    fi
  done
}

function topng() {
  [ "$#" -eq 0 ] && echo "Please specify at least 1 file";
  for var in "$@"; do 
    FILENAME=`echo ${var##*/}`;
    NOEXT=`echo ${FILENAME%\.*}`
    sips -s format png "$var" --out "$NOEXT".png
    sips -i "$NOEXT".png
  done
}

function ppdirs() {
  find /Volumes/GoFlex |sed '/GoFlex\/\./d' > ~/Desktop/ppdirs.txt
}

function camclean() {
  file_path="/Users/bernhard/Dropbox/Camera Uploads/" # Slash at the end!
  SAVEIFS=$IFS
  IFS=$(echo -en "\n\b")
  for f in $(ls $file_path ); do
    if [ "${f:0:4}" != "Icon" ]; then
      if [ "${f:4:1}" == "-" ] && 
         [ "${f:7:1}" == "-" ]; then
        oldname="$file_path$f"
        replace=$(echo "$f" | sed 's/-/./1' | sed 's/-/./1' )
        newname="$file_path$replace"
        echo "$oldname"
        mv "$oldname" "$newname"
      fi
    fi 
  done
  IFS=$SAVEIFS
}

### Mac Specific Aliases
alias ls='ls -G'      # color the ls output
alias ll='ls -GFlash' # shortcut for detailed listing
alias less='less -IR' # better less
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias my="~/.my_helpers.sh"
alias bm="~/Books/1_BookManager.php"
alias opent="open -a 'Sublime Text 2'"

### General Aliases
alias cds="cd;hidehomedirs;clear" # Go home an clear screen
alias grep='grep --color=auto' # colored grep
alias ducks='du -cksh *'       # folders and files sizes in current folder
alias untar="tar xvzf"         # untar
alias top='top -o cpu'         # Sort top by CPU
alias m2='man2pdf'             # Shortcut for manpages
alias pyserv='python -m SimpleHTTPServer 8080'
