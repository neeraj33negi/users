# lib/my_railtie.rb
require 'rails/railtie'

class MyRailtie < Rails::Railtie
  # Adding a custom initializer
  initializer "my_railtie.configure_rails_initialization" do |app|
    puts "Initializing MyRailtie"
  end

  # Adding a custom generator
  generators do
    require_relative 'generators/my_generator/my_generator_generator'
  end
end
