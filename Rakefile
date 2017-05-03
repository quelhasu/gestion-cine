require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rake/testtask'

task :default => [:test, :test_acceptation]

task :unitaire => [:test]
task :acceptation => [:test_acceptation]

Rake::TestTask.new(:test_acceptation) do |t|
  t.libs << "test_acceptation"
  t.test_files = FileList['test_acceptation/ajouter_test.rb']
end

Rake::TestTask.new(:wip) do |t|
  t.libs << "test_acceptation"
  t.test_files = FileList['test_acceptation/init_test.rb']
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/*_test.rb']
end

task :ch_perms do
 sh "chmod +x bin/gestion-cine"
end
