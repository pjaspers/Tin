require 'rake'
require "ghrunit"

task :default => [:test]

desc "Cleans the build folder"
task :clean do
  `rm -rf build/*`
end

desc "Cleans the build folder"
task :test do
  ENV['GHUNIT_CLI']="1"
  GHRunit.new(:target => "tests")
end
