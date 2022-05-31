# frozen_string_literal: true

module SolidusDevSupport
  VERSION = "2.5.4"

  def self.gem_version
    Gem::Version.new(VERSION)
  end
end
