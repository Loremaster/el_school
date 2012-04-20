# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: qualifications
#
#  id         :integer         not null, primary key
#  subject_id :integer
#  teacher_id :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Qualification < ActiveRecord::Base
  belongs_to :subject
  belongs_to :teacher
  
  has_many :curriculums
  has_many :school_classes, :through => :curriculums
end
