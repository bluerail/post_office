# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: post_office 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "post_office".freeze
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Rene van Lieshout".freeze]
  s.date = "2022-01-17"
  s.description = "A mock SMTP/POP3 server to aid in the development of applications with mail functionality.".freeze
  s.email = "rene@bluerail.nl".freeze
  s.executables = ["post_office".freeze, "post_officed".freeze]
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = [
    "LICENSE",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/post_office",
    "bin/post_officed",
    "lib/config_file.rb",
    "lib/generic_server.rb",
    "lib/pop_server.rb",
    "lib/smtp_server.rb",
    "lib/startup_item.rb",
    "lib/store.rb",
    "post_office.gemspec",
    "startup_item/PostOffice/PostOffice",
    "startup_item/PostOffice/StartupParameters.plist"
  ]
  s.homepage = "http://github.com/bluerail/post_office".freeze
  s.rubygems_version = "3.0.9".freeze
  s.summary = "PostOffice mock SMTP/POP3 server".freeze
end

