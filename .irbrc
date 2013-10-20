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
  require "#{Rails.root}/spec/spec_helper.rb" if File.exists?("#{Rails.root}/spec/spec_helper.rb")
  ActiveRecord::Base.logger = Logger.new(STDOUT)
  #ActiveResource::Base.logger = Logger.new(STDOUT)

  if defined? Hirb
    Hirb.enable
  end
end

if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

class Object
  def interesting_methods
    (self.methods - Object.new.methods).sort
  end
  def which_method(method_name)
    self.method(method_name.to_sym)
  end
end
