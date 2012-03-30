namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_admin
    make_school_head
  end
end

def make_admin
  admin = User.new( :user_login => "admin", :password => "qwerty" ) 
  admin.user_role = "admin"
  admin.save
end

def make_school_head
  school_head = User.new( :user_login => "sh", :password => "qwerty" )
  school_head.user_role = "school_head"
  school_head.save 
end


