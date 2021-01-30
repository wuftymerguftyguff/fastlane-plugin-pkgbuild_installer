require 'fastlane/action'
require_relative '../helper/pkgbuild_installer_helper'

module Fastlane
  module Actions
    class PkgbuildInstallerAction < Action
      def self.run(params)
        # from params
        bundle_path = params[:src_bundle_path]
        package_path = params[:package]
        installer_cert_name = params[:installer_cert_name]
        relocatable = params[:relocatable]
        verbose = params[:verbose]

        # derived from params
        bundle_path_last =  File.basename(bundle_path)

        Dir.mktmpdir do |dir|
          tmppkgpath=File.join(dir,"Package")
          analysisplistpath = File.join(dir,"bundle.plist")
          Dir.mkdir(tmppkgpath)
          FileUtils.cp_r(bundle_path, tmppkgpath)
          Actions.sh(
            "xcrun pkgbuild --root \"#{tmppkgpath}\" --analyze \"#{analysisplistpath}\"",
            log: verbose
          )
          # get identifier from bundle
          infoplistpath=File.join(dir,"Package",bundle_path_last,"Contents","Info.plist")
          bundleidentifier = other_action.get_info_plist_value(path: infoplistpath, key: "CFBundleIdentifier")

          # get version from bundle
          bundleversion = other_action.get_info_plist_value(path: infoplistpath, key: "CFBundleShortVersionString")

          # get BundleIsRelocatable from bundle analysis
          puts analysisplistpath


          bundleisrelocatable = Actions.sh(
             "/usr/libexec/PlistBuddy -c \"Print :0:BundleIsRelocatable\" \"#{analysisplistpath}\"",
             log: verbose
           ).strip


          # update analysis plist as required

          Actions.sh(
            "/usr/libexec/PlistBuddy -c  \"set :0:BundleIsRelocatable \"#{relocatable}\"\" \"#{analysisplistpath}\"",
            log: verbose
          )

            bundleisrelocatable = Actions.sh(
               "/usr/libexec/PlistBuddy -c \"Print :0:BundleIsRelocatable\" \"#{analysisplistpath}\"",
               log: verbose
             ).strip
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
                                       is_string: true),
            FastlaneCore::ConfigItem.new(key: :src_bundle_path,
                                       env_name: 'FL_PKGBUILD_SRC_BUNDLE',
                                       description: 'Path to  bundle to package e.g. .app bundle',
                                       is_string: true,
                                       verify_block: proc do |value|
                                         UI.user_error!("Could not find package at '#{value}'") unless File.exist?(value)
                                       end),
            FastlaneCore::ConfigItem.new(key: :installer_cert_name,
                                      env_name: 'FL_PKGBUILD_INSTALLER_CERT',
                                      description: 'Full name of 3rd Party Mac Developer Installer or Developer ID Installer certificate. Example: 3rd Party Mac Developer Installer: Your Company (ABC1234XWYZ)',
                                      optional: false,
                                      is_string: true),
            FastlaneCore::ConfigItem.new(key: :verbose,
                                      env_name: 'FL_PKGBUILD_VERBOSE',
                                      description: 'Whether to log requests',
                                      optional: true,
                                      default_value: false,
                                      type: Boolean),
            FastlaneCore::ConfigItem.new(key: :relocatable,
                                      env_name: 'FL_PKGBUILD_RELOCATABLE',
                                      description: 'Whether to build a relocatable install package',
                                      optional: true,
                                      default_value: false,
                                      type: Boolean)
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
