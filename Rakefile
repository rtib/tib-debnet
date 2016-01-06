require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

# a dirty litle hack around puppetlabs_spec_helper
exclude_paths = ["test/**/*.pp","vendor/**/*.pp","examples/**/*.pp","spec/**/*.pp","pkg/**/*.pp"]

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
    config.disable_checks = []
    config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
    config.fail_on_warnings = true
    config.ignore_paths = exclude_paths
end
