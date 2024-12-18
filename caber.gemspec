require_relative "lib/caber/version"

Gem::Specification.new do |spec|
  spec.name = "caber"
  spec.version = Caber::VERSION
  spec.authors = ["James Smith"]
  spec.email = ["james@floppy.org.uk"]
  spec.homepage = "https://github.com/manyfold3d/caber"
  spec.summary = "A simple ReBAC / Zanzibar gem for Rails apps."
  spec.description = "A simple ReBAC / Zanzibar gem for Rails apps."
  spec.license = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/manyfold3d/caber"
  spec.metadata["changelog_uri"] = "https://github.com/manyfold3d/caber/releases"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.1.4"
  spec.add_development_dependency "rspec-rails", "~> 7.1"
  spec.add_development_dependency "factory_bot_rails", "~> 6.4"
  spec.add_development_dependency "standardrb"
  spec.add_development_dependency "simplecov", "~> 0.22"
end
