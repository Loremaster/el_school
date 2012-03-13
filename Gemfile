source 'http://rubygems.org'

gem 'rails', '3.2'                                                            #'3.1.3'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'                                                            #,   '~> 3.1.5'
  gem 'coffee-rails'                                                          #, '~> 3.1.1'
  gem 'uglifier'                                                              #, '>= 1.0.3'
end

gem 'jquery-rails'

group :development do
  gem 'rspec-rails'                                                           #, '2.6.1'
  gem 'therubyracer-heroku'
  gem 'pg'                                                                    #For postgreSQL  
  gem 'annotate', :git => 'git://github.com/ctran/annotate_models.git'        #It is patched version from github. This one works.
  gem 'faker'                                                                 #automating filling db by test data.
end

group :test do
  gem 'turn', '~> 0.8.3', :require => false                                   # Pretty printed test output
  gem 'rspec-rails'                                                           
  gem 'webrat'                                                                
  gem 'spork'
  gem 'autotest'                                                                                                              
  gem 'autotest-rails-pure'                                                                                                   
  gem 'autotest-fsevent'                                                                                                      
  gem 'autotest-growl'                                                                                                          
  gem 'factory_girl_rails'
end

group :production do  
  gem 'pg'                                                                    #For postgreSQL 
end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


