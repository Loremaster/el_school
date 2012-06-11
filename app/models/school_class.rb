# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: school_classes
#
#  id                     :integer         not null, primary key
#  teacher_leader_id      :integer
#  class_code             :string(255)
#  date_of_class_creation :date
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

class SchoolClass < ActiveRecord::Base
  attr_accessible :class_code,
                  :date_of_class_creation,
                  :teacher_leader_id,
                  :pupil_ids,
                  :qualification_ids                                                      # We use this to save ids in Curriculum table.

  belongs_to :teacher_leader

  has_many :pupils
  has_many :curriculums
  has_many :qualifications, :through => :curriculums
  has_many :orders
  has_many :meetings
  has_many :timetables
  has_many :events
  has_many :homeworks

  validates :class_code,
              :presence   => { :message => "не может быть пустым" },
              :uniqueness => { :message => "должен быть уникальным" },
              :length     => {
                                :maximum => 3,
                                :message => "должен содержать не более 3 символов"
                             }

  validates :date_of_class_creation,
              :inclusion => {
                                :in => ( Date.today - 1.year )..( Date.today + 1.year ),
                                :message => "должна находиться в пределах одного года от текущей даты"
                             }

  validates :teacher_leader_id,
              :uniqueness => { :message => "уже является классным руководителем класса" },
              :presence   => { :message => "должен иметь выбранного классного руководителя" }
end
