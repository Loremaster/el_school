# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: attendances
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  lesson_id  :integer
#  visited    :boolean
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Attendance < ActiveRecord::Base
  belongs_to :pupil
  belongs_to :lesson

  validates :pupil_id, :presence => { :message => "должен быть указан" }
  validates :lesson_id, :presence => { :message => "должен быть указан" }
end
