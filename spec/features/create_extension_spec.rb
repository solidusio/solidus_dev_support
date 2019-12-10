# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Create extension' do # rubocop:disable Metrics/BlockLength
  let(:ext_root) { File.expand_path('../..', __dir__) }
  let(:solidus_cmd) { "#{ext_root}/exe/solidus" }
  let(:extension_name) { 'test_extension' }
  let(:gemspec_name) { "solidus_#{extension_name}.gemspec" }
  let(:tmp_path) { Pathname.new(ext_root).join('spec', 'tmp') }
  let(:install_path) { tmp_path.join("solidus_#{extension_name}") }
  let(:command_failed) { Class.new(StandardError) }

  around do |example|
    tmp_path.mkpath
    example.run
    tmp_path.rmtree
  end

  def check_solidus_cmd
    output = cd(tmp_path) { `#{solidus_cmd} extension -h` }
    expect($?).to be_success
    expect(output).to include('Usage')
  end

  def check_create_extension
    output = `cd #{tmp_path} && #{solidus_cmd} extension #{extension_name}`
    expect($?).to be_success
    expect(output).to include(gemspec_name)
    expect(output).to include('.circleci')
  end

  def check_bundle_install
    expect { sh("cd #{install_path} && bundle install 2>&1") }.to(
      raise_error(command_failed, /invalid gemspec/)
    )
    # Update gemspec with the required fields
    gemspec_path = install_path.join(gemspec_name)
    new_content = gemspec_path.read.gsub(/\n.*s.author[^\n]+/, "\n  s.author = 'someone'").gsub(/TODO/, 'something')
    gemspec_path.write(new_content)
    expect(sh("cd #{install_path} && bundle install 2>&1")).to include('Bundle complete!')
  end

  def check_default_task
    output = sh("cd #{install_path} && bundle exec rake 2>&1")
    expect(output).to include('Generating dummy Rails application')
    expect(output).to include('no offenses detected')
    expect(output).to include('0 examples, 0 failures')
  end

  def check_run_specs
    install_path.join('spec', 'some_spec.rb').write(
      "require 'spec_helper'\nRSpec.describe 'Some test' do it { expect(true).to be_truthy } end\n"
    )
    output = sh("cd #{install_path} && bundle exec rspec 2>&1")
    expect(output).to include('1 example, 0 failures')
    expect(output).to include('Coverage report generated')
  end

  def sh(*args)
    command = args.size == 1 ? args.first : args.shelljoin
    output = Bundler.with_clean_env { `#{command}` }
    $?.success? ? output : raise(command_failed, "command failed: #{command} \n#{output}")
  end

  it 'checks the create extension process' do
    check_solidus_cmd
    check_create_extension
    check_bundle_install
    check_default_task
    check_run_specs
  end
end
