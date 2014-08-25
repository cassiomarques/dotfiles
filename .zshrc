# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="cassiomarques"

LANG=en_AU.UTF-8

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git gem lein)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
# export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH:/opt/local/bin:/opt/local/sbin:/Users/cassiommc/.rvm/gems/ruby-1.9.2-p180/bin:/Users/cassiommc/.rvm/gems/ruby-1.9.2-p180@global/bin:/Users/cassiommc/.rvm/rubies/ruby-1.9.2-p180/bin:/Users/cassiommc/.rvm/bin:~/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$PATH:/opt/local/bin:/opt/local/sbin:~/bin:/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:/usr/local/git/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin

# REE
export RUBY_HEAP_MIN_SLOTS=1000000
export RUBY_HEAP_SLOTS_INCREMENT=1000000
export RUBY_HEAP_SLOTS_GROWTH_FACTOR=1
export RUBY_GC_MALLOC_LIMIT=1000000000
export RUBY_HEAP_FREE_MIN=500000

export RESQUE_AUTH=123456

export USE_JASMINE_RAKE=true

# Aliases
# misc
alias vim="mvim -v"
# alias vim='/Applications/MacVim.app/Contents/MacOS/Vim'
export GEM_EDITOR="mvim -v"
export EDITOR="mvim -v"
alias cshdb="psql -U postgres -h 10.10.1.9 -d csh"
alias csldb="psql -U postgres -h 10.10.1.9 -d csl"

# git
alias gl='git log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %Cblue%an%Creset - %s %Cgreen(%cr)%Creset'\'' --abbrev-commit --date=relative'
alias ga='git add .'
alias gs='git status'
alias gp='git push'
alias gd="git diff"

# tig
alias ts="tig status"

# Rails 2
alias ss="script/server"
alias sc="script/console"
alias db="script/dbconsole"

# Rails 3
alias rc="rails console"
alias rs="rails server"
alias rdb="rails dbconsole"
alias migrate="bundle exec rake db:migrate db:test:prepare"
alias pryr="bundle exec pry -r './config/environment'"

# SHH
alias ebb="cd ~/dev/shh/eblood_blood_bank"
alias elab="cd ~/dev/shh/eblood_laboratories"

# Leiningen (Clojure)
alias lein='nocorrect lein'

alias spin="nocorrect spin"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.
# rvm use default

#PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Zeus aliases
alias zspec="zeus rspec"
alias zserver="zeus server"
alias zake="zeus rake"
alias zgen="zeus rails g"

# Ruby stuff aliases
alias be="bundle exec"
alias b="bundle"
alias bspec="bundle exec rspec"

