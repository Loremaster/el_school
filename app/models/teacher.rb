# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: teachers
#
#  id                  :integer         not null, primary key
#  user_id             :integer
#  teacher_last_name   :string(255)
#  teacher_first_name  :string(255)
#  teacher_middle_name :string(255)
#  teacher_birthday    :date
#  teacher_sex         :string(255)
#  teacher_category    :string(255)
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#

class Teacher < ActiveRecord::Base
  attr_accessible :teacher_last_name,
                  :teacher_first_name,
                  :teacher_middle_name,
                  :teacher_birthday,
                  :teacher_sex,
                  :teacher_category,
                  :teacher_education_attributes,
                  :teacher_phone_attributes,
                  :subject_ids

  belongs_to :user                                              
  
  has_one :teacher_education
  has_one :teacher_phone
  has_one :teacher_leader
  
  has_many :qualifications
  has_many :subjects, :through => :qualifications
  has_many :events
     
  accepts_nested_attributes_for :teacher_education
  accepts_nested_attributes_for :teacher_phone
                       
  validates :teacher_last_name,   
              :presence   => { :message => "не может быть пустой" },             
              :length     => { 
                               :maximum => 40,
                               :message => "должна содержать не более 40 символов" 
                             }
                                                                  
  validates :teacher_first_name,  
              :presence   => { :message => "не может быть пустым" },             
              :length     => { 
                               :maximum => 40,
                               :message => "должно содержать не более 40 символов" 
                             }
                                 
  validates :teacher_middle_name, 
              :presence   => { :message => "не может быть пустым" },             
              :length     => { 
                               :maximum => 40,
                               :message => "должно содержать не более 40 символов" 
                             }
                                   
  validates :teacher_sex,         
              :presence  => true,
              :inclusion => { :in => %w(m w) }
                                  
  validates :teacher_category,                                                            # Might be empty as i understand.
              :length   => { 
                            :maximum => 20,
                            :message => "должна содержать не более 20 символов" 
                           }         
          
  validates :teacher_birthday, 
              :inclusion => {
                              :in => Date.civil(1970, 1, 1)..Date.today,
                              :message => "должна быть с 1970 по сегодняшний день"
                             }
                             
end
