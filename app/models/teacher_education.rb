# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teacher_educations
#
#  id                           :integer         not null, primary key
#  teacher_id                   :integer
#  teacher_education_university :string(255)
#  teacher_education_year       :date
#  teacher_education_graduation :string(255)
#  teacher_education_speciality :string(255)
#  created_at                   :datetime        not null
#  updated_at                   :datetime        not null
#

class TeacherEducation < ActiveRecord::Base
  attr_accessible :teacher_education_university,
                  :teacher_education_year,
                  :teacher_education_graduation,
                  :teacher_education_speciality

  belongs_to :teacher

  validates :teacher_education_university,
              :presence   => { :message => "не может быть пустым" },
              :length     => {
                                :maximum => 100,
                                :message => "должно содержать не более 100 символов"
                             }

  validates :teacher_education_year,
              :inclusion => {
                               :in => Date.civil(1970, 1, 1)..( Date.today + 1.year ),
                               :message => "должна быть с 1970 по 1 год вперед от сегодняшней даты"
                            }

  validates :teacher_education_graduation,
              :presence   => { :message => "не может быть пустой" },
              :length     => {
                                :maximum => 30,
                                :message => "должна содержать не более 30 символов"
                              }

  validates :teacher_education_speciality,
              :presence   => { :message => "не может быть пустой" },
              :length     => {
                                :maximum => 30,
                                :message => "должна содержать не более 30 символов"
                              }
end
