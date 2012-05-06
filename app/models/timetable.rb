# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: timetables
#
#  id                  :integer         not null, primary key
#  curriculum_id       :integer
#  school_class_id     :integer
#  tt_day_of_week      :string(255)
#  tt_number_of_lesson :integer
#  tt_room             :string(255)
#  tt_type             :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class Timetable < ActiveRecord::Base
  belongs_to :curriculum
  belongs_to :school_class
  
  validates :school_class_id, :presence => { :message => "должен быть указан" }
                  
  validates :tt_day_of_week,
              :presence  => true,
              :inclusion => { :in => %w(Mon Tue Wed Thu Fri) }
  
  validates :tt_number_of_lesson,
              :presence => true,
              :inclusion => { 
                              :in => 1..9, 
                              :message => "должен быть как минимум одним (но не более 9)"
                            }
              
  validates :tt_room,
              :length => { 
                           :maximum => 3,
                           :message => "должен содержать не более 3 символов" 
                         }, 
              :allow_blank => true

  validates :tt_type,
              :inclusion => { :in => ["Primary lesson", "Extra"] },
              :allow_blank => true
end
