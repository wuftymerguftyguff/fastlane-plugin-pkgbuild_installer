require 'fastlane/action'
require_relative '../helper/pkgbuild_installer_helper'

module Fastlane
  module Actions
    class PkgbuildInstallerAction < Action
      def self.run(params)
        bundle_path = params[:src_bundle_path]
        package_path = params[:package]
        Dir.mktmpdir do |dir|
          tmppkgpath=File.join(dir,tmppkgpath)
          Dir.mkdir(tmppkgpath)
          FileUtils.cp_r(bundle_path, tmppkgpath, :verbose => true )
          puts Dir.glob("*")
        end
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
            FastlaneCore::ConfigItem.new(key: :package,
                                       env_name: 'FL_PKGBUILD_TGT_PACKAGE',
                                       description: 'Path to installer package we will build',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find package at '#{value}'") unless File.exist?(value)
                                       end),
            FastlaneCore::ConfigItem.new(key: :src_bundle_path,
                                       env_name: 'FL_PKGBUILD_SRC_BUNDLE',
                                       description: 'Path to  bundle to package e.g. .app bundle',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find package at '#{value}'") unless File.exist?(value)
                                       end)
        ]
      end

      def self.is_supported?(platform)
        # Adjust this if your plugin only works for a particular platform (iOS vs. Android, for example)
        # See: https://docs.fastlane.tools/advanced/#control-configuration-by-lane-and-by-platform
        #
        platform == :mac
      end
    end
  end
end
