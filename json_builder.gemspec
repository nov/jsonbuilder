# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{json_builder}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["nov"]
  s.date = %q{2009-06-06}
  s.description = %q{Builder::XmlMarkup like JsonBuilder (Builder::JsonMarkup)}
  s.email = %q{nov@matake.jp}
  s.extra_rdoc_files = ["README", "ChangeLog"]
  s.files = ["README", "ChangeLog", "Rakefile", "spec/builder", "spec/builder/json_markup_spec.rb", "spec/spec_helper.rb", "lib/builder", "lib/builder/json_markup.rb", "lib/json_builder.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://jsonbuilder.rubyforge.org}
  s.rdoc_options = ["--title", "json_builder documentation", "--charset", "utf-8", "--opname", "index.html", "--line-numbers", "--main", "README", "--inline-source", "--exclude", "^(examples)/"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{jsonbuilder}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Builder::XmlMarkup like JsonBuilder (Builder::JsonMarkup)}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
