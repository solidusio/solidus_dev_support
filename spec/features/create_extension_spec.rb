# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'spec_helper'

RSpec.describe 'Create extension' do # rubocop:disable Metrics/BlockLength
  include FileUtils

  let(:ext_root) { File.expand_path('../..', __dir__) }
  let(:solidus_cmd) { "#{ext_root}/exe/solidus" }
  let(:extension_name) { 'test_extension' }
  let(:gemspec_name) { "solidus_#{extension_name}.gemspec" }
  let(:tmp_path) { Pathname.new(ext_root).join('tmp') }
  let(:install_path) { tmp_path.join("solidus_#{extension_name}") }

  class CommandFailed < StandardError; end

  before do
    rm_rf(install_path)
    mkdir_p(tmp_path)
  end

  it 'checks the create extension process' do
    check_solidus_cmd
    check_create_extension
    check_bundle_install
    check_default_task
    check_run_specs
  end

  private

  def check_solidus_cmd
    cd(tmp_path) do
      output = `#{solidus_cmd} -h`
      expect($?).to be_success
      expect(output).to include('Commands:')
    end
  end

  def check_create_extension
    cd(tmp_path) do
      output = `#{solidus_cmd} extension #{extension_name}`
      expect($?).to be_success
      expect(output).to include(gemspec_name)
      expect(output).to include('.circleci')
    end
  end

  def check_bundle_install
    cd(install_path) do
      open('Gemfile', 'a') { |f| f.puts "gem 'solidus_dev_support', path: '../../..'" }
    end

    expect { bundle_install }.to raise_error(CommandFailed, /invalid gemspec/)

    # Update gemspec with the required fields
    gemspec_path = install_path.join(gemspec_name)
    new_content = gemspec_path.read.gsub(/\n.*s.author[^\n]+/, "\n  s.author = 'someone'").gsub(/TODO/, 'https://example.com')
    gemspec_path.write(new_content)

    expect(bundle_install).to match(/Bundle complete/)
  end

  def check_default_task
    cd(install_path) do
      output = sh('bundle exec rake')
      expect(output).to include('Generating dummy Rails application')
      expect(output).to include('0 examples, 0 failures')
    end
  end

  def check_run_specs
    install_path.join('spec', 'some_spec.rb').write(
      "require 'spec_helper'\nRSpec.describe 'Some test' do it { expect(true).to be_truthy } end\n"
    )
    cd(install_path) do
      output = sh('bundle exec rspec')
      expect(output).to include('1 example, 0 failures')
      expect(output).to include(ENV['CI'] ? 'Coverage reports upload successfully' : 'Coverage report generated')
    end
  end

  def sh(*args)
    command = args.size == 1 ? args.first : args.shelljoin
    stdout, stderr, status = Bundler.with_clean_env { Open3.capture3(command) }
    status.success? ? stdout.to_s : raise(CommandFailed, "command failed: #{command}\n#{stderr}\n#{stdout}")
  end

  def bundle_install
    command = 'bundle install'
    command += " --path=#{ext_root}/vendor/bundle" if ENV['CI']

    cd(install_path) { sh command }
  end
end
