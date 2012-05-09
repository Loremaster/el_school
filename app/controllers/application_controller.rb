# encoding: UTF-8
require 'date'

class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  #Check that date has format - dd.mm.yyyy.
  #Check that such date exists.
  def date_valid? ( date_in_str )
    regex = /\A\d{2}\.\d{2}\.\d{4}\z/                                                     # 2 digits.2 digits.4 digits
    
    if date_in_str =~ regex
       date_to_parse = date_in_str.gsub('.', '/')                                         # Using / instead of . because such version can pe parsed
       begin
          date = Date.strptime( date_to_parse, '%d/%m/%Y' ) 
          Date.parse( date.to_s )
          return true
       rescue
          return false
       end
    else
       return false
    end   
  end
  
  # Get class code for current class head.
  def get_class_code( current_user )
    current_user.teacher_leader.school_class.class_code
  end
  
  # Get parent for class via class code.
  # => [] if there were no parents.
  def get_parents_for_class( class_code )
    parents = []                                                                          # Output.
    pupils = Pupil.select{|p| p.school_class.class_code == class_code }                   # Get pupils for class via class_code of class.
    pupils.each{ |p| parents << p.parents }                                               # Get parents for each pupil.
    
    if parents.empty?
      parents
    else
      parents.flatten!.uniq!                                                              # Turn multy-dimension array into one dimension array (each parent for pupil got their array). And then keep only unique parents.
    end
  end
end
