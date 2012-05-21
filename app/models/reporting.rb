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

  validates :lesson_id, :presence => { :message => "должен быть указан" }

  # homework - домашняя работа.
  # classwork - работа на уроке.
  # labwork - лабораторная работа.
  # checkpoint - контрольная работа.
  validates :report_type,
              :presence  => { :message => "должен быть указан" },
              :inclusion => { :in => %w(homework classwork labwork checkpoint) }

  validates :report_topic,
              :length     => {
                               :maximum => 200,
                               :message => "должна содержать не более %{count} символов"
                             }
end
