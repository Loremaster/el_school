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

  validates :pupil_id, :presence => { :message => "должен быть указан" }

  validates :reporting_id, :presence => { :message => "должен быть указан" }

  validates :nominal, :inclusion => { :in => 2..5,
                                      :message => "должна быть цифрой от 2 до 5" },
                      :allow_nil => true
end
