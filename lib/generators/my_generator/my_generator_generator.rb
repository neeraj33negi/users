# lib/my_generator.rb
require 'rails/generators'

class MyGeneratorGenerator < Rails::Generators::Base
  def create_initializer_file
    create_file "config/initializers/my_initializer.rb", "# Add initialization content here"
  end
end
