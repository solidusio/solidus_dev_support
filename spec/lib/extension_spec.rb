require 'solidus_dev_support/extension'

RSpec.describe SolidusDevSupport::Extension do
  describe '#default_homepage' do
    before do
      expect(subject).to receive(:git).with('remote get-url origin', any_args).and_return(remote)
      expect(subject).to receive(:github_user).and_return('[USERNAME]')
      expect(subject).to receive(:file_name).and_return('solidus_foo_bar')
    end

    context 'with a git ssh-style remote' do
      let(:remote) { 'git@github.com:solidusio-contrib/solidus_extension_dev_tools.git' }

      it 'generates a github home page value' do
        expect(subject.default_homepage).to eq('https://github.com/solidusio-contrib/solidus_extension_dev_tools')
      end
    end

    context 'with a git https remote' do
      let(:remote) { 'https://github.com/solidusio-contrib/solidus_extension_dev_tools.git' }

      it 'generates a github home page value' do
        expect(subject.default_homepage).to eq('https://github.com/solidusio-contrib/solidus_extension_dev_tools')
      end
    end
  end

  describe '#default_gemspec' do
    it 'has a changelog_uri' do
      expect(subject.default_gemspec.metadata['changelog_uri']).to end_with('/releases')
    end
  end
end
