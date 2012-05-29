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
end
