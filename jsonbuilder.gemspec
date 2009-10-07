# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{jsonbuilder}
  s.version = "0.2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov"]
  s.date = %q{2009-10-07}
  s.description = %q{Builder::XmlMarkup like JsonBuilder}
  s.email = %q{nov@matake.jp}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "spec/spec_helper.rb", "spec/builder", "spec/builder/xml_markup_spec.rb", "spec/builder/json_format_spec.rb", "spec/builder/array_mode_spec.rb", "spec/builder/hash_structure_spec.rb", "spec/ext", "spec/ext/stackable_hash_spec.rb", "spec/ext/stackable_array_spec.rb", "spec/jsonbuilder_spec.rb", "lib/builder", "lib/builder/json_format.rb", "lib/builder/abstract.rb", "lib/builder/xml_markup.rb", "lib/builder/hash_structure.rb", "lib/jsonbuilder.rb", "lib/patch", "lib/patch/active_support_json_decode.rb", "lib/ext", "lib/ext/stackable_array.rb", "lib/ext/stackable_hash.rb"]
  s.homepage = %q{http://jsonbuilder.rubyforge.org}
  s.rdoc_options = ["--title", "jsonbuilder documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jsonbuilder}
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Builder::XmlMarkup like JsonBuilder}
  s.test_files = ["spec/jsonbuilder_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<builder>, [">= 0"])
    else
      s.add_dependency(%q<builder>, [">= 0"])
    end
  else
    s.add_dependency(%q<builder>, [">= 0"])
  end
end
