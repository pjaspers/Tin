require 'rake'

task :default => [:default]

desc "Default action"
task :default do

end

desc "Cleans the build folder"
task :clean do
  `rm -rf build/*`
end

desc "Cleans the build folder"
task :test do
  ENV['GHUNIT_CLI']="1"
  puts %x{xcodebuild -target tests -configuration Debug -sdk iphonesimulator build}
end
