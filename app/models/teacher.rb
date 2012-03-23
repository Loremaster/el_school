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
                  :teacher_education_attributes

  belongs_to :user                                              
  
  has_one :teacher_education
  has_one :teacher_phone
  
  accepts_nested_attributes_for :teacher_education
   
  # date_regexp = /\A\d{2}\.\d{2}\.\d{4}\z/                                               #dd.mm.yyyy
   
  # validates :user_id,             
  #             :presence => true                                                           #That means that we can't create teacher like that - Teacher.new(...). We should create it like that - @user.create_teacher( @attr_teacher )      
                    
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
                                  
  validates :teacher_category,                                                            #Might be empty as i understand.
              :length   => { 
                            :maximum => 20,
                            :message => "должна содержать не более 20 символов" 
                           }         
          
  validates :teacher_birthday, 
              :inclusion => {
                              :in => Date.civil(1970, 1, 1)..Date.today,
                              :message => "должна быть с 1970 по сегодняшний день"
                             }
  
  # validate :validate_teacher_birthday                                           
  
  # private
  # 
  #   def validate_teacher_birthday
  #     errors.add(:teacher_birthday, "is invalid.") unless ( check_valid_date)
  #   end
  # 
  #   # def valid_date_format
  #   #   parts = self.teacher_birthday.to_s.split("-")
  #   #   formatted_date_in_str = "#{parts[2]}.#{parts[1]}.#{parts[0]}"  
  #   #   formatted_date_in_str.match(/[0-9][0-9].[0-9][0-9].[0-9][0-9][0-9][0-9]/)
  #   # end
  # 
  #   def check_valid_date
  #         begin
  #           parts = self.teacher_birthday.to_s.split("-") #contains array of the form [day,month,year]
  #           Date.civil(parts[2].to_i,parts[1].to_i,parts[0].to_i)
  #           return true
  #         rescue ArgumentError
  #           #ArgumentError is thrown by the Date.civil method if the date is invalid
  #           false
  #         end
  #       end
  
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
