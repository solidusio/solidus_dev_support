# frozen_string_literal: true

require "solidus_support"
require "solidus_extension_dev_tools/version"
require "solidus_extension_dev_tools/engine_extensions"

module SolidusExtensionDevTools
  class Error < StandardError; end

  class << self
    def reset_spree_preferences_deprecated?
      first_version_without_reset = Gem::Requirement.new('>= 2.9')
      first_version_without_reset.satisfied_by?(SolidusSupport.solidus_gem_version)
    end
  end
end
