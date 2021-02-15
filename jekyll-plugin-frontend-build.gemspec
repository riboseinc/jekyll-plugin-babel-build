# frozen_string_literal: true

require_relative "lib/jekyll/frontend_builder/version"

all_files_in_git = `git ls-files -z`.split("\x0")

Gem::Specification.new do |s|
  s.name          = "jekyll-plugin-frontend-build"
  s.version       = Jekyll::FrontendBuilder::VERSION
  s.authors       = ["Ribose Inc."]
  s.email         = ["open.source@ribose.com"]

  s.summary       = "Jekyll plugin that post-processes static assets with Babel"
  s.homepage      = "https://github.com/riboseinc/jekyll-plugin-frontend-build/"
  s.license       = "MIT"

  s.files         = all_files_in_git.grep_v(%r{^(test|spec|features)/})

  s.add_runtime_dependency "jekyll", "~> 4.0"
  s.add_development_dependency "pry", "~> 0.14.0"
  s.add_development_dependency "rake", "~> 12.0"
  s.add_development_dependency "rubocop", "~> 0.50"
  s.requirements << "Node.js with npm"
end
