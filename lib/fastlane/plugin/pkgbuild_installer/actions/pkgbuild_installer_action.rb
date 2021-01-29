require 'fastlane/action'
require_relative '../helper/pkgbuild_installer_helper'

module Fastlane
  module Actions
    class PkgbuildInstallerAction < Action
      def self.run(params)
        UI.message("The pkgbuild_installer plugin is working!")
      end

      def self.description
        "Install pkg builder targeted at Developer ID applications"
      end

      def self.authors
        ["Jeff Arthur"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "This plugin will create an install package from an app bundle"
      end

      def self.available_options
        [
          # FastlaneCore::ConfigItem.new(key: :your_option,
          #                         env_name: "PKGBUILD_INSTALLER_YOUR_OPTION",
          #                      description: "A description of your option",
          #                         optional: false,
          #                             type: String)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        # [:ios, :mac, :android].include?(platform)
        true
      end
    end
  end
end
