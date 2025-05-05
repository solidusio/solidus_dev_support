require "solidus_dev_support/extension"

RSpec.describe SolidusDevSupport::Extension do
  describe "#path=" do
    specify "with an existing extension" do
      allow(subject).to receive(:git).with("remote get-url origin", any_args).and_return("git@github.com:some_user/solidus_my_ext.git")
      allow(subject).to receive(:git).with("config user.name", any_args).and_return("John Doe")
      allow(subject).to receive(:git).with("config user.email", any_args).and_return("john.doe@example.com")

      allow(File).to receive(:exist?).with("/foo/bar/solidus_my_ext/solidus_my_ext.gemspec").and_return(true)
      allow(Gem::Specification).to receive(:load).with("/foo/bar/solidus_my_ext/solidus_my_ext.gemspec").and_return(
        Gem::Specification.new("solidus_my_ext", "0.1.1") do |gem|
          gem.author = "Jane Doe"
          gem.email = "jane.doe@example.com"

          gem.summary = "This extension is awesome!"
          gem.license = "MIT"

          gem.homepage = "some_user.github.io/solidus_my_ext"
          gem.metadata["changelog_uri"] = "https://github.com/some_user/solidus_my_ext/releases"
          gem.metadata["source_code_uri"] = "https://github.com/some_user/solidus_my_ext"
        end
      )

      subject.path = "/foo/bar/solidus_my_ext"

      aggregate_failures do
        expect(subject.file_name).to eq("solidus_my_ext")
        expect(subject.class_name).to eq("SolidusMyExt")
        expect(subject.root).to eq("/foo/bar")
        expect(subject.path).to eq("/foo/bar/solidus_my_ext")
        expect(subject.repo).to eq("some_user/solidus_my_ext")
        expect(subject.gemspec.author).to eq("Jane Doe")
        expect(subject.gemspec.email).to eq("jane.doe@example.com")
        expect(subject.gemspec.summary).to eq("This extension is awesome!")
        expect(subject.gemspec.license).to eq("MIT")
        expect(subject.gemspec.homepage).to eq("some_user.github.io/solidus_my_ext")
        expect(subject.gemspec.metadata["changelog_uri"]).to eq("https://github.com/some_user/solidus_my_ext/releases")
        expect(subject.gemspec.metadata["source_code_uri"]).to eq("https://github.com/some_user/solidus_my_ext")
      end
    end

    specify "when creating a new extension" do
      allow(subject).to receive(:git).with("remote get-url origin", any_args) { |_, default| default }
      allow(subject).to receive(:git).with("config user.name", any_args).and_return("John Doe")
      allow(subject).to receive(:git).with("config user.email", any_args).and_return("john.doe@example.com")

      allow(Dir).to receive(:pwd).and_return("/foo/bar")

      subject.path = "/foo/bar/solidus_my_ext"

      aggregate_failures do
        expect(subject.file_name).to eq("solidus_my_ext")
        expect(subject.class_name).to eq("SolidusMyExt")
        expect(subject.root).to eq("/foo/bar")
        expect(subject.path).to eq("/foo/bar/solidus_my_ext")
        expect(subject.repo).to eq("solidusio-contrib/solidus_my_ext")
        expect(subject.gemspec.author).to eq("John Doe")
        expect(subject.gemspec.email).to eq("john.doe@example.com")
        expect(subject.gemspec.summary).to eq("TODO: Write a short summary, because RubyGems requires one.")
        expect(subject.gemspec.description).to eq("TODO: Write a longer description or delete this line.")
        expect(subject.gemspec.license).to eq("BSD-3-Clause")
        expect(subject.gemspec.homepage).to eq("https://github.com/solidusio-contrib/solidus_my_ext#readme")
        expect(subject.gemspec.metadata["changelog_uri"]).to eq("https://github.com/solidusio-contrib/solidus_my_ext/blob/main/CHANGELOG.md")
        expect(subject.gemspec.metadata["source_code_uri"]).to eq("https://github.com/solidusio-contrib/solidus_my_ext")
      end
    end
  end
end
