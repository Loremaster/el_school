# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teachers
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  teacher_last_name   :string(255)
#  teacher_first_name  :string(255)
#  teacher_middle_name :string(255)
#  teacher_birthday    :date
#  teacher_sex         :string(255)
#  teacher_category    :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#

class Teacher < ActiveRecord::Base
  attr_accessible :teacher_last_name,
                  :teacher_first_name,
                  :teacher_middle_name,
                  :teacher_birthday,
                  :teacher_sex,
                  :teacher_category

  belongs_to :user
                  
  validates :teacher_last_name,   :presence => true,             
                                  :length   => { :maximum => 40 }
                                                                  
  validates :teacher_first_name,  :presence => true,             
                                  :length   => { :maximum => 40 }
                                 
  validates :teacher_middle_name, :presence => true,                                             
                                  :length   => { :maximum => 40 }
                                  
  validates :teacher_sex,         :presence => true,
                                  :inclusion => { :in => %w(м ж) }
                                  
  validates :teacher_category,    :length   => { :maximum => 20 }             #Might be empty as i understand.
  
  validates :user_id,             :presence => true                           #That means that we can't create teacher like that - Teacher.new(...). We should create it like that - @user.create_teacher( @attr_teacher )      
end
