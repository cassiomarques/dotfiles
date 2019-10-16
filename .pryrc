# frozen_string_literal: true

Pry.prompt = [
  proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " },
  proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }
]
Pry.config.editor = 'nvim'

alias q exit
Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'

# Prompt!
Pry.config.prompt = proc do |_, level, pry|
  tree = pry.binding_stack.map { |b| Pry.view_clip(b.eval('self')) }.join ' / '
  "(pry) #{tree}: #{level}> "
end

# Load plugins (only those I whitelist)
Pry.config.should_load_plugins = false
Pry.plugins['doc'].activate!
