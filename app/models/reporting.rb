# encoding: UTF-8
# == Schema Information
#
# Table name: reportings
#
#  id           :integer         not null, primary key
#  report_type  :string(255)
#  report_topic :string(255)
#  lesson_id    :integer
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Reporting < ActiveRecord::Base
  belongs_to :lesson

  has_one :estimation

  # homework - домашняя работа.
  # classwork - работа на уроке.
  # labwork - лабораторная работа.
  # checkpoint - контрольная работа.
  # year_result - годовая отчетность.
  # intermediate_result - промежуточная отчетность.
  validates :report_type,
              :presence  => { :message => "должен быть указан" },
              :inclusion => { :in => %w(homework classwork labwork checkpoint year_result
                                        intermediate_result),
                              :message => "не имеет верного значения"
                            }

  validates :report_topic,
              :length     => { :maximum => 200,
                               :message => "должна содержать не более %{count} символов"
                             }
end
