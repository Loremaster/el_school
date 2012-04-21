# encoding: UTF-8
namespace :db do
  desc "Fill database with sample data"
  task :populate => :environment do
    Rake::Task['db:reset'].invoke
    make_admin
    make_school_head
  end
  
  desc "Fill database with generated teacher leader"
  task :populate_teacher_leader => :environment do
    make_teacher_leader
  end
  
  desc "Fill database with subjects"
  task :populate_subjects => :environment do
    make_subjects
  end
  
  desc "Fill database with subjects"
  task :populate_pupils => :environment do
    make_pupil
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

def make_teacher_leader
  teacher = make_teacher
  
  user_leader = make_user( "class_head" )
  attr_teacher_leader = {
    :user_id => user_leader.id,
    :teacher_id => teacher.id
  }
  
  user_leader.create_teacher_leader( attr_teacher_leader )              
end

def make_user( role )
  user = User.new( :user_login => random_str( 10 ), 
                   :password => "qwerty" )
  user.user_role = role
  user.save
  user
end

def make_teacher
  attr_teacher = {
                  :teacher_last_name   => "Каров_#{random_digit_str( 4 )}",
                  :teacher_first_name  => "Петр",
                  :teacher_middle_name => "Иванович",
                  :teacher_birthday    => "01.12.1980",                                                
                  :teacher_sex         => "m",
                  :teacher_category    => "1я Категория"
                 }
  
  user_teacher = make_user( "teacher" )  
  teacher = user_teacher.create_teacher( attr_teacher )
end

def make_subjects
  subjects = %w(Математика Русский Физика Литература Химия)
  subjects.each{|s| Subject.create( { :subject_name => s } ) }
end

def make_pupil
  user = make_user( "pupil" )
  attr_pupil = {
    :pupil_last_name => "Смирнов_#{random_digit_str( 4 )}",
    :pupil_first_name => "Петр",
    :pupil_middle_name => "Петрович",
    :pupil_birthday => "#{Date.today - 10.years}",
    :pupil_sex => "m",
    :pupil_nationality => "Русский",
    :pupil_address_of_registration => "Москва, ул. Ленина, д. 1",
    :pupil_address_of_living => "Москва, ул. Ленина, д. 1"
  }
  user.create_pupil( attr_pupil )
end

private
  # Return string with random chars. If size is not set then return string with length == 1.
  # random_str( 2 ) => "XD"
  # random_str => "X"
  def random_str( size=1 )
    (0...size).map{65.+(rand(25)).chr}.join
  end
  
  # Return string with random digits. If size is not set then return string with length == 1.
  # random_digit_str( 2 ) => "12"
  # random_digit_str => "1"
  def random_digit_str( size=1 )
    rand(10 ** size)
  end