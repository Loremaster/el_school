class JournalsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]

  def index
    @subject = []; @pupils = []
    @teacher_subjects = current_user.teacher.subjects                                     # This we get when user choose subject from toolbar.
    @subject = Subject.where( "subject_name = ?", params[:subject_name] ).first
    @classes = SchoolClass.all
    school_class = SchoolClass.where( "class_code = ?", params[:class_code] ).first

    @lessons = teacher_lessons_dates( current_user.teacher, @subject, school_class )
    @lessons_exist = @lessons.first ? true : false

    @pupils = Pupil.select{|p| p.school_class.class_code == school_class.class_code } unless school_class.nil?
    @pupils_exist = @pupils.first ? true : false
  end

  private

    # Collecting lessons for teacher eith subject ans school_class.
    # => Array.
    def teacher_lessons_dates( teacher, subject, school_class )
      return [] if teacher.nil? || subject.nil? || school_class.nil?                      # Some of that can be nil.

      lessons = []
      teacher_timetables = timetables_for_teacher_with_subject( teacher,                  # Get all timetables of teacher for input class and subject. This method is in application_controller.
                                                                subject.subject_name,
                                                                school_class )
      teacher_timetables.each { |t| lessons << t.lessons }                                # Collecting lessons.
      lessons.flatten!                                                                    # To 1 dimension array (because of many-to-one).
    end
end
