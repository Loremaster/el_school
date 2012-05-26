# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: pupils
#
#  id                            :integer         not null, primary key
#  user_id                       :integer
#  school_class_id               :integer
#  pupil_last_name               :string(255)
#  pupil_first_name              :string(255)
#  pupil_middle_name             :string(255)
#  pupil_birthday                :date
#  pupil_sex                     :string(255)
#  pupil_nationality             :string(255)
#  pupil_address_of_registration :string(255)
#  pupil_address_of_living       :string(255)
#  created_at                    :datetime        not null
#  updated_at                    :datetime        not null
#

class Pupil < ActiveRecord::Base
  belongs_to :user
  belongs_to :school_class

  has_one  :pupil_phone
  has_one  :estimation

  has_many :orders
  has_many :parent_pupils
  has_many :parents, :through => :parent_pupils
  has_many :attendances

  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :pupil_phone


  validates :pupil_last_name,
              :presence   => { :message => "не может быть пустой" },
              :length     => {
                               :maximum => 40,
                               :message => "должна содержать не более 40 символов"
                             }

  validates :pupil_first_name,
              :presence   => { :message => "не может быть пустым" },
              :length     => {
                               :maximum => 40,
                               :message => "должно содержать не более 40 символов"
                             }

  validates :pupil_middle_name,
              :presence   => { :message => "не может быть пустым" },
              :length     => {
                               :maximum => 40,
                               :message => "должно содержать не более 40 символов"
                             }

   validates :pupil_birthday,
              :inclusion => {
                              :in => ( Date.today - 19.year )..( Date.today - 5.year ),
                              :message => "должна быть в пределах от 5 до 19 лет от текущего года"
                            }

   validates :pupil_sex,
               :presence  => true,
               :inclusion => { :in => %w(m w) }

   validates :pupil_nationality,
               :presence => { :message => "не может быть пустой" },
               :length   => {
                              :maximum => 50,
                              :message => "должна содержать не более 50 символов"
                            }

   validates :pupil_address_of_registration,
               :presence => { :message => "не может быть пустым" },
               :length   => {
                              :maximum => 250,
                              :message => "должен содержать не более 250 символов"
                            }

   validates :pupil_address_of_living,
               :presence => { :message => "не может быть пустым" },
               :length   => {
                              :maximum => 250,
                              :message => "должен содержать не более 250 символов"
                            }
end
