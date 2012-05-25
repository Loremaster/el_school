# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: estimations
#
#  id           :integer         not null, primary key
#  reporting_id :integer
#  pupil_id     :integer
#  nominal      :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Estimation < ActiveRecord::Base
  belongs_to :pupil
  belongs_to :reporting
end
