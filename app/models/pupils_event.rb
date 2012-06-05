# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: pupils_events
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  event_id   :integer
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class PupilsEvent < ActiveRecord::Base
  belongs_to :pupil
  belongs_to :event

  validates :pupil_id, :presence => { :message => "должен быть указан" }
  validates :event_id, :presence => { :message => "должно быть указано" }
end
