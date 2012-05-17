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

  def get_class_code( current_user )
    current_user.teacher_leader.school_class.class_code
  end

  # Get class code for current class head.
  def get_class( current_user )
    current_user.teacher_leader.school_class
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

  # Day of week to russian word.
  def translate_day_of_week( day )
    days = { :Mon => "Понедельник", :Tue => "Вторник", :Wed => "Среда", :Thu => "Четверг",
             :Fri => "Пятница" }
    days[ day.to_sym ]
  end

  # Get ALL timetables for teacher
  # => Array
  def timetables_for_teacher_with_subject( teacher, subject_name, school_class )
    tt = []                                                                               # Output timetables
    subject = teacher.subjects.where(:subject_name => subject_name).first                 # Get subject for teacher.
    subject_qualification = teacher.qualifications.where(:subject_id => subject.id).first # Qualification for subject.
    curriculums = subject_qualification.curriculums                                       # Get all curriculums
    curriculums.each { |c| tt << c.timetables  }                                          # Collecting all timetables.
    tt.flatten!                                                                           # To 1 dimension array (because of many-to-one).
    tt.select{|t| t.school_class.class_code == school_class.class_code }                  # Finding all timetables for 1 SCHOOL CLASS.
  end
end
