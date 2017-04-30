# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','gestion-cine','version.rb'])
spec = Gem::Specification.new do |s|
  s.name = 'gestion-cine'
  s.version = GestionCine::VERSION
  s.author = 'Ugo Quelhas'
  s.email = 'uquelhas@gmail.com'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Application pour la gestion d un cinema (banque de films)'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = false
  s.extra_rdoc_files = ['README.rdoc','gestion-cine.rdoc']
  s.rdoc_options << '--title' << 'gestion-cine' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'gestion-cine'
  s.add_development_dependency('rake')
  s.add_development_dependency('aruba')
  s.add_development_dependency('minitest')
  s.add_development_dependency('json')
  s.add_development_dependency('omdbapi')
  s.add_runtime_dependency('gli','2.14.0')
end
