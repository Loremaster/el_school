# encoding: UTF-8
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
  
  validates :teacher_id, 
              :uniqueness => { :message => "уже является классным руководителем" }
end
