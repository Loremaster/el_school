# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: orders
#
#  id              :integer         not null, primary key
#  pupil_id        :integer
#  school_class_id :integer
#  number_of_order :string(255)
#  date_of_order   :date
#  text_of_order   :text
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

class Order < ActiveRecord::Base
  belongs_to :pupil
  belongs_to :school_class
  
  validates :number_of_order,
              :presence   => { :message => "не может быть пустым" },
              :length     => { 
                               :maximum => 15,
                               :message => "должен содержать не более 15 символов" 
                             }
                             
  validates :date_of_order,
              :presence   => { :message => "не может быть пустым" },
              :inclusion => {
                                 :in => ( Date.today - 1.year )..( Date.today + 1.year ),
                                 :message => "должен находиться в пределах одного года от текущей даты"
                             }
  
  validates :text_of_order,                                                                                 
              :presence   => { :message => "не может быть пустым" },                                          
              :length     => {                                                                                
                               :maximum => 500,                                                                
                               :message => "должен содержать не более 500 символов"                            
                             }                                                                                                           
end
