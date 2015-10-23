# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "jasper-on-rails-pdf/version"

Gem::Specification.new do |s|
  s.name        = "jasper-on-rails-pdf"
  s.version     = JasperOnRailsPdf::VERSION
  s.authors     = ["Thiago Cifani"]
  s.summary     = %q{Rails and JasperReports integration}
  s.description = %q{Generate pdf reports on Rails using Jasper Reports reporting tool}
  s.email       = "cifani.thiago@gmail.com"
  s.homepage    = "https://github.com/thiagocifani/jasper-on-rails-pdf"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rjb-loader', '~>0.0.2'
  s.add_dependency 'nokogiri'
  s.add_development_dependency 'combustion', '~> 0.3.2'
  s.add_development_dependency "rspec-rails"
end
