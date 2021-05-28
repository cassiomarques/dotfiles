# frozen_string_literal: true

Pry.config.editor = 'nvim'

alias q exit

# Prompt!
# Pry.config.prompt = proc do |_, level, pry|
#   tree = pry.binding_stack.map { |b| Pry.view_clip(b.eval('self')) }.join ' / '
#   "(pry) #{tree}: #{level}> "
# end
#
default_prompt = Pry::Prompt[:default]
Pry.config.prompt = Pry::Prompt.new(
  'custom',
  'my custom prompt',
  [
    proc { |*args| default_prompt.wait_proc.call(*args).to_s },
    proc { |*args| default_prompt.incomplete_proc.call(*args).to_s },
  ]
)

