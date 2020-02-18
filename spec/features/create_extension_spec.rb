# frozen_string_literal: true

require 'fileutils'
require 'open3'
require 'spec_helper'

RSpec.describe 'Create extension' do # rubocop:disable Metrics/BlockLength
  include FileUtils

  let(:gem_root) { File.expand_path('../..', __dir__) }
  let(:solidus_cmd) { "#{gem_root}/exe/solidus" }
  let(:extension_name) { 'test_extension' }
  let(:gemspec_name) { "solidus_#{extension_name}.gemspec" }
  let(:tmp_path) { Pathname.new(gem_root).join('tmp') }
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
    check_sandbox
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

    cd(install_path) do
      %w[
        bin/setup
        bin/r
        bin/console
        bin/sandbox
        bin/sandbox_rails
      ].each do |bin|
        bin = Pathname(bin)
        expect(bin.exist?).to eq(true)
        expect(bin.stat.executable?).to eq(true)
      end
    end
  end

  def check_bundle_install
    cd(install_path) do
      open('Gemfile', 'a') { |f| f.puts "gem 'solidus_dev_support', path: '../../..'" }
    end

    expect { bundle_install }.to raise_error(CommandFailed, /invalid gemspec/)

    # Update gemspec with the required fields
    gemspec_path = install_path.join(gemspec_name)
    gemspec = gemspec_path.read.lines
    gemspec.grep(/spec\.author/).first.replace("  spec.author = 'John Doe'\n")
    gemspec.grep(/spec\.email/).first.replace("  spec.email = 'john@example.com'\n")
    gemspec.grep(/spec\.summary/).first.replace("  spec.summary = 'A nice extension'\n")
    gemspec.grep(/spec\.description/).first.replace("  spec.description = 'A super nice extension'\n")
    gemspec_path.write(gemspec.join)

    expect(bundle_install).to match(/Bundle complete/)
  end

  def check_default_task
    cd(install_path) do
      output = sh('bin/rake')
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
      expect(output).to include(ENV['CODECOV_TOKEN'] ? 'Coverage reports upload successfully' : 'Provide a CODECOV_TOKEN environment variable to enable Codecov uploads')
    end
  end

  def check_sandbox
    cd(install_path) do
      command = 'bin/sandbox_rails runner "puts %{The version of SolidusTestExtension is #{SolidusTestExtension::VERSION}}"'
      first_run_output = sh(command)
      expect(first_run_output).to include("Creating the sandbox app...")
      expect(first_run_output).to include('The version of SolidusTestExtension is 0.0.1')

      second_run_output = sh(command)
      expect(second_run_output).not_to include("Creating the sandbox app...")
      expect(second_run_output).to include('The version of SolidusTestExtension is 0.0.1')
    end
  end

  def sh(*args)
    command = args.size == 1 ? args.first : args.shelljoin
    output, status = with_unbundled_env { Open3.capture2e(command) }

    if status.success?
      output.to_s
    else
      if $DEBUG
        warn '~'*80
        warn "$ #{command}"
        warn output.to_s
      end
      raise(CommandFailed, "command failed: #{command}\n#{output}")
    end
  end

  def with_unbundled_env(&block)
    if Bundler.respond_to?(:with_unbundled_env)
      Bundler.with_unbundled_env(&block)
    else
      Bundler.with_clean_env(&block)
    end
  end

  def bundle_install
    # Optimize the bundle path within the CI, in this context using bundler env
    # variables doesn't help because commands are run with a clean env.
    bundle_path = "#{gem_root}/vendor/bundle"

    command = 'bundle install'
    command += " --path=#{bundle_path.shellescape}" if File.exist?(bundle_path)

    output = nil
    cd(install_path) { output = sh command }
    output
  end
end
