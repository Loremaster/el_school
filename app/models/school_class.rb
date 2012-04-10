# Created by 'bundle exec annotate --position before'
# == Schema Information
#
# Table name: school_classes
#
#  id                     :integer         not null, primary key
#  teacher_leader_id      :integer
#  class_code             :string(255)
#  date_of_class_creation :date
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#

class SchoolClass < ActiveRecord::Base
  attr_accessible :class_code,
                  :date_of_class_creation
                  
  belongs_to :teacher_leader
                  
  validates :class_code,
              :presence   => { :message => "не может быть пустым" },            
              :length     => { 
                                :maximum => 3,
                                :message => "должен содержать не более 3 символов" 
                             }
                             
  validates :date_of_class_creation, 
              :inclusion => {
                                :in => ( Date.today - 1.year )..( Date.today + 1.year ),
                                :message => "должна находиться в пределах одного года от текущей даты"
                             }
end
