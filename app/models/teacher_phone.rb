# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teacher_phones
#
#  id                    :integer         not null, primary key
#  teacher_id            :integer
#  teacher_home_number   :string(255)
#  teacher_mobile_number :string(255)
#  created_at            :datetime        not null
#  updated_at            :datetime        not null
#

class TeacherPhone < ActiveRecord::Base
  attr_accessible :teacher_home_number,
                  :teacher_mobile_number
  
  belongs_to :teacher 
    
  validates :teacher_home_number,
              :presence   => { :message => "не может быть пустым" },     
              :length     => { 
                                :maximum => 15,
                                :message => "должен содержать не более 15 символов"
                              }
                              
  validates :teacher_mobile_number,
              :presence   => { :message => "не может быть пустым" },     
              :length     => { 
                                :maximum => 15,
                                :message => "должен содержать не более 15 символов"
                              }
end
