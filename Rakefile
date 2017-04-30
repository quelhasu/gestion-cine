require 'rake/clean'
require 'rubygems'
require 'rubygems/package_task'
require 'rake/testtask'

# task :default => [:test, :test_acceptation]

task :tests => [:test]

Rake::TestTask.new(:test_acceptation) do |t|
  t.libs << "test_acceptation"
  t.test_files = FileList['test_acceptation/*_test.rb']
end

Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.test_files = FileList['test/film_test.rb']
end

task :init do
 sh "cp -f test_acceptation/cours.txt.5+1 .cours.txt"
end

task :ch_perms do
 sh "chmod +x bin/gestion-cine"
end
