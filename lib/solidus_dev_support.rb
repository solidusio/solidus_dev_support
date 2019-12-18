# frozen_string_literal: true

require "solidus_dev_support/version"

module SolidusDevSupport
  class Error < StandardError; end

  class << self
    def reset_spree_preferences_deprecated?
      first_version_without_reset = Gem::Requirement.new('>= 2.9')
      first_version_without_reset.satisfied_by?(Spree.solidus_gem_version)
    end
  end
end
