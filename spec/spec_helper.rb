require "rspec"
require "pry"

require "pymn"
$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)

RSpec.configure do |config|
  config.color_enabled = true
  config.before(:each) do
    @lib_dir = File.expand_path('../../lib', __FILE__)
  end
end



