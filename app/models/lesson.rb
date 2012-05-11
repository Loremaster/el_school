# == Schema Information
#
# Table name: lessons
#
#  id           :integer         not null, primary key
#  timetable_id :integer
#  lesson_date  :date
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Lesson < ActiveRecord::Base
  belongs_to :timetable
end
