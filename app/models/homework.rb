# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: homeworks
#
#  id         :integer         not null, primary key
#  pupil_id   :integer
#  lesson_id  :integer
#  task_text  :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

class Homework < ActiveRecord::Base
  belongs_to :pupil
  belongs_to :lesson

  validates :pupil_id, :presence => { :message => "должен быть указан" }

  validates :lesson_id, :presence => { :message => "должен быть указан" }

  validates :task_text,
              :length => { :maximum => 250,
                           :message => "должно содержать не более %{count} символов"}
end
