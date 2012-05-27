# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: results
#
#  id            :integer         not null, primary key
#  pupil_id      :integer
#  curriculum_id :integer
#  quarter_1     :integer
#  quarter_2     :integer
#  quarter_3     :integer
#  quarter_4     :integer
#  year          :integer
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

class Result < ActiveRecord::Base
  belongs_to :pupil
  belongs_to :curriculum

  validates :pupil_id, :presence => { :message => "должен быть указан" }

  validates :curriculum_id, :presence => { :message => "должна быть указана" }

  validates :quarter_1, :inclusion => { :in => 2..5,
                                        :message => "должна быть цифрой от 2 до 5" },
                        :allow_nil => true

  validates :quarter_2, :inclusion => { :in => 2..5,
                                        :message => "должна быть цифрой от 2 до 5" },
                        :allow_nil => true

  validates :quarter_3, :inclusion => { :in => 2..5,
                                        :message => "должна быть цифрой от 2 до 5" },
                        :allow_nil => true

  validates :quarter_4, :inclusion => { :in => 2..5,
                                        :message => "должна быть цифрой от 2 до 5" },
                        :allow_nil => true

  validates :year, :inclusion => { :in => 2..5,
                                        :message => "должна быть цифрой от 2 до 5" },
                   :allow_nil => true
end
