class JournalsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]

  def index_for_parent
    @pupil = nil; @pupil_curriculums_exist = false; @pupil_lessons_exist = false

    if params.has_key?( :p_id )                                                           # If parent chose his pupil.
      @pupil = Pupil.where( "id = ?", params[:p_id] ).first

      @pupil_curriculums = curriculums_for_pupil( @pupil )
      @pupil_curriculums_exist = @pupil_curriculums.first ? true : false

      if params.has_key?( :curr_id )                                                      # If parent chose subject.
        curriculum = Curriculum.where( "id = ?", params[:curr_id] ).first

        @choosen_lesson = curriculum.qualification.subject                                # Choosen lesson from dropdown menu.

        @pupil_lessons = lessons_for_one_curriculum( curriculum )
        @pupil_lessons_exist = @pupil_lessons.first ? true : false
      end
    end
  end

  def index
    @subject = []; @pupils = []
    @teacher_subjects = current_user.teacher.subjects                                     # This we get when user choose subject from toolbar.
    @classes = SchoolClass.all
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )

    @lessons = teacher_lessons_dates( current_user.teacher, @subject, @school_class )     # Lessons of teacher.
    @lessons_exist = @lessons.first ? true : false

    @pupils = get_pupils_for_class( @school_class )                                       # Pupils in the class.
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
      lessons.flatten.sort_by{ |e| e[:lesson_date] }                                      # To 1 dimension array (because of many-to-one). Then sorting by date.
    end
end
