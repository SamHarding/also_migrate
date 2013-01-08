# -*- encoding: utf-8 -*-
root = File.expand_path('../', __FILE__)
lib = "#{root}/lib"
$:.unshift lib unless $:.include?(lib)
 
require 'also_migrate/gems'
Gem::Specification.new do |s|
  AlsoMigrate::Gems.gemspec.hash.each do |key, value|
    if key == 'name' && AlsoMigrate::Gems.gemset != :default
      s.name = "#{value}-#{AlsoMigrate::Gems.gemset}"
    elsif key == 'summary' && AlsoMigrate::Gems.gemset == :solo
      s.summary = value + " (no dependencies)"
    elsif !%w(dependencies development_dependencies).include?(key)
      s.send "#{key}=", value
    end
  end

  s.executables = `cd #{root} && git ls-files -- {bin}/*`.split("\n").collect { |f| File.basename(f) }
  s.files = `cd #{root} && git ls-files`.split("\n")
  s.require_paths = %w(lib)
  s.test_files = `cd #{root} && git ls-files -- {features,test,spec}/*`.split("\n")
end