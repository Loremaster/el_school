source 'http://rubygems.org'

gem 'rails', '3.2.11'
gem 'jquery-rails'
gem 'yaml_db'
gem 'pg'                                                                                            # Connect to postgreSQL.
gem 'less-rails', '2.2.6'                                                                           # twitter-bootstrap-rails needs that now.
gem 'therubyracer', :platform => :ruby
gem 'simple_form', '2.0.2'
gem 'slim', '1.3.6'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.4'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.2.3'
  gem 'twitter-bootstrap-rails', '2.2.0'
end

group :development do
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'                              # It is patched version from github. This one works.
  gem 'faker', '1.0.1'                                                                              # Automatically filling db by test data.
  gem 'capistrano', '2.12.0'                                                                        # Deploying to server. Be carefull with changing version!
  gem 'meta_request'                                                                                # Panel in chrome to debug rails apps.
  gem 'rails-erd'
end

group :test do
  gem 'turn', '~> 0.8.3', :require => false                                                         # Pretty printed test output.
  gem 'webrat', '0.7.3'
  gem 'spork', '0.9.0'                                                                              # DRB server.
  gem 'autotest'
  gem 'autotest-rails-pure'
  gem 'autotest-fsevent'
  gem 'autotest-growl'
  gem 'factory_girl_rails', '3.1.0'                                                                 # Gem to quickly create objects of models.
end

group :development, :test do
  gem 'rspec-rails', '2.12.2'
  gem 'rb-fsevent'#, :require => false if RUBY_PLATFORM =~ /darwin/i                                # Installing this gem only if we use darwin platform (e.g Mac OS X).
  gem 'guard-rspec'                                                                                 # Rspec for guard.
  gem 'ruby_gntp'                                                                                   # Show notifications from guard by growl.
  gem 'guard-livereload'                                                                            # This gem allows guard automatically refresh page in browser if we changed something in files. Works ok only with Safari, also you need to install extension.
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


