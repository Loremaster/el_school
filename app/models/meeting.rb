# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: meetings
#
#  id              :integer         not null, primary key
#  school_class_id :integer
#  meeting_theme   :string(255)
#  meeting_date    :date
#  meeting_time    :time
#  meeting_room    :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Meeting < ActiveRecord::Base
  belongs_to :school_class

  has_many :parent_meetings
  has_many :parents, :through => :parent_meetings

  scope :fresh_meetings, lambda { where("meeting_date >= ?", Date.today ) }

  validates :school_class_id,
              :presence => { :message => "должен быть указан" }

  validates :meeting_theme,
              :presence   => { :message => "не может быть пустой" },
              :length     => {
                                :maximum => 200,
                                :message => "должна содержать не более 200 символов"
                             }

  validates :meeting_date,
              :inclusion => {
                                :in => ( Date.today - 1.year )..( Date.today + 1.year ),
                                :message => "должна находиться в пределах одного года от текущей даты"
                             }

  validates :meeting_time,
              :presence => { :message => "не может быть пустым" },
              :length   => {
                             :minimum => 5,
                             :message => "должно содержать 5 символов"
                           }

  validates :meeting_room,
              :presence   => { :message => "не может быть пустым" },
              :length     => {
                                :maximum => 4,
                                :message => "должен содержать не более 4 символов"
                             }
end
