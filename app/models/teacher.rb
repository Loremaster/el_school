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
#  created_at          :datetime
#  updated_at          :datetime
#

class Teacher < ActiveRecord::Base
  attr_accessible :teacher_last_name,
                  :teacher_first_name,
                  :teacher_middle_name,
                  :teacher_birthday,
                  :teacher_sex,
                  :teacher_category

  belongs_to :user#, dependent => :destroy                                                 #If we delete teacher, we delete his user row too.
   
  # date_regexp = /\A\d{2}\.\d{2}\.\d{4}\z/                                               #dd.mm.yyyy
   
  validates :user_id,             :presence => true                                       #That means that we can't create teacher like that - Teacher.new(...). We should create it like that - @user.create_teacher( @attr_teacher )      
                    
  validates :teacher_last_name,   :presence => true,             
                                  :length   => { :maximum => 40 }
                                                                  
  validates :teacher_first_name,  :presence => true,             
                                  :length   => { :maximum => 40 }
                                 
  validates :teacher_middle_name, :presence => true,                                             
                                  :length   => { :maximum => 40 }
                                   
  validates :teacher_sex,         :presence => true,
                                  :inclusion => { :in => %w(m w) }
                                  
  validates :teacher_category,    :length   => { :maximum => 20 }                         #Might be empty as i understand.
          
  validates :teacher_birthday, :inclusion => {
                                              :in => Date.civil(1970, 1, 1)..Date.today,
                                              :message => "Дата должна быть с 1970 по сегодняшний день"
                                             }
  
  # validates :teacher_birthday, :presence => true,
  #                                :unless   => :date_is_correct?
  #
  #   ########
  #
  #   def date_is_correct?
  #      parsed_data = Date._parse(:teacher_birthday)
  #      input_day   = parsed_data[:mday]
  #      input_month = parsed_data[:mon]
  #      input_year  = parsed_data[:year]
  #
  #      correct_days   = 1..30
  #      correct_months = 1..12
  #      correct_year   = 1900..2000
  #      if ( correct_days.member? input_day ) and ( correct_months.member? input_month) and
  #         ( correct_year.member? input_year)
  #        true
  #      else
  #        errors.add(:teacher_birthday, 'date is invalid')
  #        false
  #      end
  #   end
end
