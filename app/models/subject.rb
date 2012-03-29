# encoding: UTF-8
# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: subjects
#
#  id           :integer         not null, primary key
#  subject_name :string(255)
#  created_at   :datetime        not null
#  updated_at   :datetime        not null
#

class Subject < ActiveRecord::Base
  attr_accessible :subject_name
  
  validates :subject_name,
             :presence   => { :message => "не может быть пустым" },             
             :length     => { 
                             :maximum => 30,
                             :message => "должен содержать не более 30 символов" 
                            }
end
