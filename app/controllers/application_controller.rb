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
    pupils = Pupil.select do |p|                                                          # Get pupils for class via class_code of class.
      ( not p.school_class.nil? ) and ( p.school_class.class_code == class_code )
    end
    pupils.each{ |p| parents << p.parents } unless pupils.empty?                                              # Get parents for each pupil.

    if parents.empty?
      parents
    else
      parents.flatten.uniq                                                                # Turn multy-dimension array into one dimension array (each parent for pupil got their array). And then keep only unique parents.
    end
  end

  # Get pupils for class via class code.
  # => [] if there were no pupils.
  def get_pupils_for_class( school_class )
    pupils = []

    if not school_class.nil? and not Pupil.all.empty?
      pupils = Pupil.select{|p| p.school_class == school_class }
    end

    pupils
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
    tt.flatten.select{|t| t.school_class.class_code == school_class.class_code }          # To 1 dimension array (because of many-to-one). Then finding all timetables for 1 SCHOOL CLASS.
  end

  # Return 1 curriculum for teacher.
  # => <#Curriculum> - if curriculum founded
  # => nil - if we didn't find curriculum
  def curriculum_for_teacher_with_subject_and_class( teacher, subject_name, school_class )
    subject = teacher.subjects.where(:subject_name => subject_name).first                 # Get subject for teacher.
    subject_qualification = teacher.qualifications.where(:subject_id => subject.id).first # Qualification for subject.
    curriculum = subject_qualification.curriculums.select do |c|                          # Filter curriculum
      c.school_class.class_code == school_class.class_code                                # ... via input class code
    end

    unless curriculum.empty?                                                              # If we found curriculum return it (first element in array)
      curriculum.first
    else
      nil                                                                                 # Then return nil, it will help to debug (i hope)
    end
  end

  # Return subject name and class code from params.
  # params - hash
  # :subject_name - char
  # :class_code - char
  # => subject, school_class
  def extract_class_code_and_subj_name( params, subject_name, class_code )
    subject = Subject.where( "subject_name = ?", params[:subject_name] ).first
    school_class = SchoolClass.where( "class_code = ?", params[:class_code] ).first
    return subject, school_class
  end

  # Collecting report types and translations for them.
  def collect_report_types()
    [["Домашняя работа", "homework"], ["Работа в классе", "classwork"],
     ["Лабораторная работа", "labwork"], ["Контрольная работа", "checkpoint"]]
  end

  # Collecting all nominals!
  def collect_nominals()
    (2..5).collect{ |n| [n,n] }
  end

  # Estimation for lesson of pupil.
  def estimation_of_pupil_from_lesson( lesson, pupil_id  )
    estimation = lesson.reporting.estimations.where( "pupil_id = ?", pupil_id ).first

    unless estimation.nil?
      estimation
    else
      ""
    end
  end

  # Pupil results for subject in school class.
  def pupil_results( pupil, teacher, subject_name, school_class )
    curriculum = curriculum_for_teacher_with_subject_and_class( teacher, subject_name,
                                                                school_class )
    if not curriculum.nil? and not pupil.nil?
      pupil.results.where(:curriculum_id => curriculum.id).first                          # Find results of pupil for chosen subject and class code.
    else
      nil
    end
  end

  # Return array of curriculums for pupil
  # => [] empty if no curriculums have been founded.
  def curriculums_for_pupil( pupil )
    out = []; school_class = pupil.school_class

    unless school_class.nil?
      out = school_class.curriculums
    end

    out.flatten
  end

  # Return sorted by lesson date array of lessons for one input curriculum.
  # => [] if no lessons founded.
  def lessons_for_one_curriculum( curriculum )
    out = []

    timetables = curriculum.timetables

    unless timetables.empty?
      out = timetables.collect{ |t| t.lessons }
    end

    out.flatten.sort_by{|e| e[:lesson_date]}
  end

  # Return all school classes where teacher teach his subjects.
  # => [] if no curriculums founded.
  def teacher_school_classes( teacher )
    curriculums = teacher.qualifications.collect{ |q| q.curriculums }.flatten

    unless curriculums.empty?
      curriculums.collect{ |c| c.school_class }.flatten
    else
      return []
    end
  end
end
