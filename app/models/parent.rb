# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: parents
#
#  id                 :integer         not null, primary key
#  user_id            :integer
#  parent_last_name   :string(255)
#  parent_first_name  :string(255)
#  parent_middle_name :string(255)
#  parent_birthday    :date
#  parent_sex         :string(255)
#  created_at         :datetime        not null
#  updated_at         :datetime        not null
#

class Parent < ActiveRecord::Base
  belongs_to :user
  
  accepts_nested_attributes_for :user
  
  
  validates :parent_last_name,
              :presence   => { :message => "не может быть пустой" },
              :length     => { 
                               :maximum => 40,
                               :message => "должна содержать не более 40 символов" 
                             }

  validates :parent_first_name,                                                                              
              :presence   => { :message => "не может быть пустым" },                                         
              :length     => {                                                                               
                               :maximum => 40,                                                               
                               :message => "должно содержать не более 40 символов"                            
                             }                                                                               

  validates :parent_middle_name,                                                                             
              :presence   => { :message => "не может быть пустым" },                                         
              :length     => {                                                                               
                               :maximum => 40,                                                               
                               :message => "должно содержать не более 40 символов"                            
                             }                                                                               

  validates :parent_birthday,                                                                                                    
              :inclusion => {                                                                                                   
                              :in => ( Date.today - 100.years )..( Date.today - 18.years ),                                       
                              :message => "должна быть в пределах от 18 до 100 лет от текущего года"                            
                            }                                                                                                  

  validates :parent_sex,                                                  
              :presence  => true,                                        
              :inclusion => { :in => %w(m w) }                                                    
end
