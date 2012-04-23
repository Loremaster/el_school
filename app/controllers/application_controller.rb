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
end
