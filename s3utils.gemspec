# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "s3utils/version"

Gem::Specification.new do |s|
  s.name        = "s3utils"
  s.version     = S3utils::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["C. Jason Herrelson (midas)"]
  s.email       = ["jason@lookforwardenterprises.com"]
  s.homepage    = "http://github.com/midas/s3utils"
  s.summary     = %q{Set of classes and command line wrapper for working with Amazon S3 service.}
  s.description = %q{Set of classes and command line wrapper for working with Amazon S3 service.}

  s.rubyforge_project = "s3utils"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    development_dependencies = {
      %q<rake> => [">= 0.9.2"],
      %q<rspec> => [">= 2.6.0"],
      %q<ruby-debug19> => [">= 0.11.6"],
    }

    runtime_dependencies = {
      %q<right_aws> => [">= 2.1.0"]#,
      # %q<trollop> => ["= 1.16.2"]
    }

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      development_dependencies.each do |name, versions|
        s.add_development_dependency( name, versions )
      end

      runtime_dependencies.each do |name, versions|
        s.add_runtime_dependency( name, versions )
      end
    else
      development_dependencies.each do |name, versions|
        s.add_dependency( name, versions )
      end

      runtime_dependencies.each do |name, versions|
        s.add_dependency( name, versions )
      end
    end
  else
    development_dependencies.each do |name, versions|
      s.add_dependency( name, versions )
    end

    runtime_dependencies.each do |name, versions|
      s.add_dependency( name, versions )
    end
  end
end
