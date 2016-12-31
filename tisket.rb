require 'yaml'

module Tisket
  def self.run_spec(name)
    Manager.new(YAML.load_file(name)).run
  end
end

$LOAD_PATH << File.dirname(__FILE__)

require 'lib/task'
require 'lib/manager'
require 'lib/polling'
