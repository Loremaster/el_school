# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: events
#
#  id                   :integer         not null, primary key
#  school_class_id      :integer
#  teacher_id           :integer
#  event_place          :string(255)
#  event_place_of_start :string(255)
#  event_begin_date     :date
#  event_end_date       :date
#  event_begin_time     :time
#  event_end_time       :time
#  event_cost           :integer
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  description          :string(255)
#

class Event < ActiveRecord::Base
  belongs_to :school_class
  belongs_to :teacher

  has_many :pupils_events
  has_many :pupils, :through => :pupils_events

  scope :fresh_events, lambda { where("event_begin_date >= ?", Date.today ) }

  validates :description,
              :length     => { :maximum => 200,
                               :message => "должно содержать не более %{count} символов"
                             }

  validates :school_class_id, :presence => { :message => "должен быть указан" }

  validates :teacher_id, :presence => { :message => "должен быть указан" }

  validates :event_place,
              :presence   => { :message => "не может быть пустым" },
              :length     => { :maximum => 200,
                               :message => "должно содержать не более %{count} символов"
                             }

  validates :event_place_of_start,
              :presence   => { :message => "не может быть пустым" },
              :length     => { :maximum => 200,
                               :message => "должно содержать не более %{count} символов"
                             }

  validates :event_begin_date,
              :inclusion => { :in => ( Date.today - 1.year )..( Date.today + 1.year ),
                              :message => "должна находиться в пределах одного года от текущей даты"
                            }

  validates :event_end_date,
              :inclusion => { :in => ( Date.today - 1.year )..( Date.today + 1.year ),
                              :message => "должна находиться в пределах одного года от текущей даты"
                            }

  validates :event_begin_time, :presence => { :message => "не может быть пустым" }

  validates :event_end_time, :presence => { :message => "не может быть пустым" }

  validates :event_cost,
              :presence => { :message => "не может быть пустой" },
              :numericality => { :message => "должна являться целым числом",
                                 :only_integer => true }

  # I use diffirents validations for one field because then it shows messages correctly.
  validates :event_cost,
              :numericality => {  :greater_than_or_equal_to => 0, :message => "должна быть не меньше 0" }

  validates :event_cost,
              :numericality => { :less_than => 100000, :message => "должна быть меньше 100000" }

  validate :start_must_be_before_or_eq_end_date
  validate :start_must_be_before_or_eq_end_time

  def start_must_be_before_or_eq_end_date
    if not self.event_begin_date.nil? and not self.event_end_date.nil?
      errors.add(:event_begin_date, "должна быть меньше либо равной дате окончания") unless
        self.event_begin_date <= self.event_end_date
    end
  end

  def start_must_be_before_or_eq_end_time
    if not self.event_begin_time.nil? and not self.event_end_time.nil? and
       not self.event_begin_date.nil? and not self.event_end_date.nil?

      errors.add(:event_begin_time, "должно быть меньше либо равно дате окончания") if
        ( self.event_begin_time >= self.event_end_time and
          self.event_begin_date == self.event_end_date )
    end
  end
end
