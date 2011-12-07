Encoding.default_external = 'UTF-8'
Encoding.default_internal = 'UTF-8'

# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Medusa::Application.initialize!
