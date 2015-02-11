# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_misc_line_item'
  s.version     = '2.1.2'
  s.summary     = 'Add Miscellaneous Items to Order'
  s.description = 'Adds ability to add Miscellaneous items to order which are tagged as LineItemeable'
  s.required_ruby_version = '>= 1.9.3'

  s.author    = 'Aditya Raghuwanshi'
  s.email     = 'adi.version1@gmail.com'
  s.homepage  = 'https://github.com/kitwalker12/spree_misc_line_item'

  #s.files       = `git ls-files`.split("\n")
  #s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.1.2'
  s.add_dependency 'spree_backend', '~> 2.1.2'

  s.add_development_dependency 'capybara', '~> 2.1'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails',  '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
