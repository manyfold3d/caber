require "caber/version"
require "caber/engine"
require "caber/configuration"

module Caber
  @@configuration = Caber::Configuration.new
  mattr_reader :configuration

  def self.configure
    yield @@configuration
  end
end
