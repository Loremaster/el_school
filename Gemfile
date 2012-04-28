source 'http://rubygems.org'

gem 'rails', '3.2'                                                                        #'3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'                                                                        
  gem 'coffee-rails'                                                                      
  gem 'uglifier'                                                                          
end

gem 'jquery-rails'

group :development do
  gem 'rspec-rails', '2.9.0'
  gem 'therubyracer-heroku'
  gem 'pg'                                                                                # For postgreSQL.  
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'                    # It is patched version from github. This one works.
  gem 'faker', '1.0.1'                                                                    # Automatically filling db by test data.
  gem 'capistrano'
end

group :test do
  gem 'turn', '~> 0.8.3', :require => false                                               # Pretty printed test output
  gem 'rspec-rails', '2.9.0'                                                           
  gem 'webrat', '0.7.3'                                                                
  gem 'spork', '0.9.0'
  gem 'autotest', '4.4.6'                                                                                                              
  gem 'autotest-rails-pure', '4.1.2'                                                                                                   
  gem 'autotest-fsevent', '0.2.8'                                                                                                      
  gem 'autotest-growl', '0.2.16'                                                                                                          
  gem 'factory_girl_rails', '3.1.0'
end

group :production do  
  gem 'pg'                                                                                # For postgreSQL. 
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


