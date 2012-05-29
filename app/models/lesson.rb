# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
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

  has_one :reporting
  has_one :homework

  has_many :attendances


  accepts_nested_attributes_for :reporting

  validates :timetable_id, :presence => { :message => "должен быть указан" }

  validates_uniqueness_of :timetable_id, :scope => :lesson_date,                          # Checking that pair of timetable_id + lesson_date should be unique together.
                          :message => "c такой датой уже существует"

  validates :lesson_date,
              :inclusion => { :in => ( Date.today - 15.years )..( Date.today + 15.years ),
                              :message => "должна находиться в пределах 15 лет от текущей даты"
                            }
end
