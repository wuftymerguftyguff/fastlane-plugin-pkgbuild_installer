describe Fastlane::Actions::PkgbuildInstallerAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The pkgbuild_installer plugin is working!")

      Fastlane::Actions::PkgbuildInstallerAction.run(nil)
    end
  end
end
