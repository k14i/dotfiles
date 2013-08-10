require 'rubygems'
require 'wirble'

if defined? Wirble
  Wirble.init
  Wirble.colorize
  colors = Wirble::Colorize.colors.merge({
    :comma => :green,
    :refers => :green,
  })
  Wirble::Colorize.colors = colors
end

begin
  require 'awesome_print'
rescue LoadError => ex
  warn ex
end

if defined? Rails::Console
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  ActiveResource::Base.logger = Logger.new(STDOUT)

  require 'spec_helper'

  if defined? Hirb
    Hirb.enable
  end
end

class Object
  def interesting_methods
    (self.methods - Object.new.methods).sort
  end
  def which_method(method_name)
    self.method(method_name.to_sym)
  end
end
