[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"  # This loads RVM into a shell session.

[ -r $rvm_path/scripts/completion ] && source $rvm_path/scripts/completion


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
