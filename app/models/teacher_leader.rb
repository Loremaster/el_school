class TeacherLeader < ActiveRecord::Base
  belongs_to :user
  belongs_to :teacher
  
  # accepts_nested_attributes_for :user
end
