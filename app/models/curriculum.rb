# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: curriculums
#
#  id               :integer         not null, primary key
#  school_class_id  :integer
#  qualification_id :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#

class Curriculum < ActiveRecord::Base
  belongs_to :school_class
  belongs_to :qualification
  
  has_many :timetables
end
