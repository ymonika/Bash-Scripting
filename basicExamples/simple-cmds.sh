## GIT CONFIG ##
parse_git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
## GIT CONFIG ##

PROMPT_COMMAND='echo -en "\033]0;$(pwd|cut -d "/" -f 5-100)\a"'

ideaKeyBorad
ibus-daemon -rd


RAM type
sudo dmidecode --type 17


ps xu | grep 'gradle' | awk '{print $2}' | xargs kill -9
ps xu | grep 'idea' | awk '{print $2}' | xargs kill -9


Sed cmd: To replace all TAB with comma,
sed -i 's/\t/,/g' Customer.csv


Symlink
ls -l SOURCE_DIR NAME_TO_BE_GIVEN


Count  no. of lines in a file
wc file.txt
