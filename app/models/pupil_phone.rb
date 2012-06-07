# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: pupil_phones
#
#  id                  :integer         not null, primary key
#  pupil_id            :integer
#  pupil_home_number   :string(255)
#  pupil_mobile_number :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class PupilPhone < ActiveRecord::Base
  belongs_to :pupil

  validates :pupil_home_number,
              :presence   => { :message => "не может быть пустым" },
              :length     => {
                                :maximum => 20,
                                :message => "должен содержать не более 20 символов"
                              },
              :numericality => { :only_integer => true,
                                 :message => "должен состоять из цифр" }

  validates :pupil_mobile_number,
              :presence   => { :message => "не может быть пустым" },
              :length     => {
                                :maximum => 20,
                                :message => "должен содержать не более 20 символов"
                              },
              :numericality => { :only_integer => true,
                                 :message => "должен состоять из цифр" }
end
