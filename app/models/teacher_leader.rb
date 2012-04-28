# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teacher_leaders
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  teacher_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class TeacherLeader < ActiveRecord::Base  
  belongs_to :user
  belongs_to :teacher
  
  has_one :school_class
    
  validates :teacher_id, 
              :uniqueness => { :message => "уже является классным руководителем" }
end
