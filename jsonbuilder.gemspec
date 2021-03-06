# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jsonbuilder}
  s.version = "0.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov matake"]
  s.date = %q{2010-08-11}
  s.description = %q{Builder::XmlMarkup like JsonBuilder}
  s.email = %q{nov@matake.jp}
  s.extra_rdoc_files = [
    "ChangeLog",
     "README"
  ]
  s.files = [
    ".gitignore",
     "ChangeLog",
     "README",
     "Rakefile",
     "VERSION",
     "jsonbuilder.gemspec",
     "lib/builder/abstract.rb",
     "lib/builder/hash_structure.rb",
     "lib/builder/json_format.rb",
     "lib/builder/xml_markup.rb",
     "lib/ext/stackable_array.rb",
     "lib/ext/stackable_hash.rb",
     "lib/jsonbuilder.rb",
     "spec/builder/array_mode_spec.rb",
     "spec/builder/hash_structure_spec.rb",
     "spec/builder/json_format_spec.rb",
     "spec/builder/xml_markup_spec.rb",
     "spec/ext/stackable_array_spec.rb",
     "spec/ext/stackable_hash_spec.rb",
     "spec/spec.opts",
     "spec/spec_helper.rb"
  ]
  s.homepage = %q{http://github.com/nov/jsonbuilder}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Builder::XmlMarkup like JsonBuilder}
  s.test_files = [
    "spec/builder/array_mode_spec.rb",
     "spec/builder/hash_structure_spec.rb",
     "spec/builder/json_format_spec.rb",
     "spec/builder/xml_markup_spec.rb",
     "spec/ext/stackable_array_spec.rb",
     "spec/ext/stackable_hash_spec.rb",
     "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 2.3.2"])
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<rcov>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 2.3.2"])
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<rcov>, [">= 0"])
  end
end

