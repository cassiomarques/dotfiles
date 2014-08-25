function pless {   pygmentize -O encoding=UTF-8 $1 | less -r; }

function rake {
  if [ -e Gemfile ]; then
    bundle exec rake $@
  else
    `which rake` $@
  fi
}

function rspec {
  if [ -e Gemfile ]; then
    bundle exec rspec $@
  else
    `which rspec` $@
  fi
}
