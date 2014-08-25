#!/usr/bin/env ruby

###################################################
# Hisb initialization code
###################################################
begin
  require 'hirb'
rescue LoadError
  # Missing goodies, bummer
end

if defined? Hirb
  # Dirty hack to support in-session Hirb.disable/enable
  Hirb::View.instance_eval do
    def enable_output_method
      @output_method = true
      Pry.config.print = proc do |output, value|
        Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value)
      end
    end

    def disable_output_method
      Pry.config.print = proc { |output, value| Pry::DEFAULT_PRINT.call(output, value) }
      @output_method = nil
    end
  end

  Hirb.enable
end

###################################################
# Pry Config
###################################################
Pry.prompt = [proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} > " }, proc { |obj, nest_level| "#{RUBY_VERSION} (#{obj}):#{nest_level} * " }]
Pry.config.editor = "vim"

alias q exit
Pry.commands.alias_command 'c', 'continue'
Pry.commands.alias_command 's', 'step'
Pry.commands.alias_command 'n', 'next'

# Prompt!
Pry.config.prompt = proc do |_, level, pry|
  tree = pry.binding_stack.map { |b| Pry.view_clip(b.eval("self")) }.join " / "
  "(pry) #{tree}: #{level}> "
end

# Load plugins (only those I whitelist)
Pry.config.should_load_plugins = false
Pry.plugins["doc"].activate!

###################################################
# Use Pry as rails console instead of IRB
###################################################
# Launch Pry with access to the entire Rails stack.
# If you have Pry in your Gemfile, you can pass: ./script/console --irb=pry instead.
# If you don't, you can load it through the lines below :)
# rails = File.join Dir.getwd, 'config', 'environment.rb'
#
# if File.exist?(rails) && ENV['SKIP_RAILS'].nil?
#   require rails
#
#   if Rails.version[0..0] == "2"
#     require 'console_app'
#     require 'console_with_helpers'
#   elsif Rails.version[0..0] == "3"
#     require 'rails/console/app'
#
#     def display_routes
#       Rails.application.reload_routes!
#       routes = Rails.application.routes.routes
#       inspector = Rails::Application::RouteInspector.new
#       puts inspector.format(routes, ENV['CONTROLLER']).join "\n"
#     end
#   else
#     warn "[WARN] cannot load Rails console commands (Not on Rails2 or Rails3?)"
#   end
#
#   def factory_load!
#     require 'factory_girl'
#     FactoryGirl.factories.clear
#
#     Dir[File.join(Rails.root, "spec/factories/*.rb")].each do |factory|
#       load factory
#     end
#
#     true
#   end
# end
#
