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

  has_many :lessons

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

  validate :timetable_should_have_curriculum_id_and_room_and_type_nil_or_with_data

  def timetable_should_have_curriculum_id_and_room_and_type_nil_or_with_data
    unless ( ( self.curriculum_id.nil? and self.tt_room.blank? and self.tt_type.blank? ) or
             ( not self.curriculum_id.nil? and not self.tt_room.blank? and
               not self.tt_type.blank? ) )
       errors.add :base, "Тип предмета, номер кабинета и тип занятия должны быть либо " +
                         "пустыми либо содержать непустые данные"
    end
  end

end
