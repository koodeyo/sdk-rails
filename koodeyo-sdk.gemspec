require_relative "lib/koodeyo/sdk/version"

Gem::Specification.new do |spec|
  spec.name        = "koodeyo-sdk"
  spec.version     = Koodeyo::Sdk::VERSION
  spec.authors     = ["Paul Jeremiah Mugaya"]
  spec.email       = ["paulmugaya@live.com"]
  spec.homepage = "https://github.com/koodeyo/sdk-rails"
  spec.summary = "Ruby on Rails Plugin for the Koodeyo SDK"
  spec.description = "Incorporates the Koodeyo Ruby SDK into a Ruby on Rails application."
  spec.license     = "MIT"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", "~> 7.0.6"
  spec.add_dependency "faraday", "~> 1.0"
  spec.add_dependency "omniauth-oauth2", "~> 1.8.0"
  spec.add_dependency "delegate"
end
