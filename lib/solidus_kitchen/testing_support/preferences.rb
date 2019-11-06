# frozen_string_literal: true

module SolidusKitchen
  module TestingSupport
    module Preferences
      # This wrapper method allows to stub spree preferences using
      # the new standard way of solidus core but also works with
      # old versions that does not have the stub_spree_preferences
      # method yet. This way we can start using this method in our
      # extensions safely.
      #
      # To have this available, it is needed to require in the
      # spec/spec_helper.rb of the extension both:
      #
      # require 'spree/testing_support/preferences'
      # require 'solidus_kitchen/testing_support/preferences'
      #
      # @example Set a preference on Spree::Config
      #   stub_spree_preferences(allow_guest_checkout: false)
      #
      # @example Set a preference on Spree::Api::Config
      #   stub_spree_preferences(Spree::Api::Config, requires_authentication: false)
      #
      # @example Set a preference on a custom Spree::CustomExtension::Config
      #  stub_spree_preferences(Spree::CustomExtension::Config, custom_pref: true)
      #
      # @param prefs_or_conf_class [Class, Hash] the class we want to stub
      #   preferences for or the preferences hash (see prefs param). If this
      #   param is an Hash, preferences will be stubbed on Spree::Config.
      # @param prefs [Hash, nil] names and values to be stubbed
      def stub_spree_preferences(prefs_or_conf_class, prefs = nil)
        super && return if SolidusKitchen.reset_spree_preferences_deprecated?

        if prefs_or_conf_class.is_a?(Hash)
          preference_store_class = Spree::Config
          preferences = prefs_or_conf_class
        else
          preference_store_class = prefs_or_conf_class
          preferences = prefs
        end
        preference_store_class.set(preferences)
      end
    end
  end
end
