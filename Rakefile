require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
require 'spree/testing_support/common_rake'

# temp fix for NoMethodError: undefined method `last_comment'
# remove when fixed in Rake 11.x
module TempFixForRakeLastComment
  def last_comment
    last_description
  end
end
Rake::Application.send :include, TempFixForRakeLastComment
### end of temfix

RSpec::Core::RakeTask.new

task default: [:spec]

desc 'Generates a dummy app for testing'
task :test_app do
  ENV['LIB_NAME'] = 'spree_flexi_variants'
  Rake::Task['common:test_app'].invoke 'Spree::User'
end
