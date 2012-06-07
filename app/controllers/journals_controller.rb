class JournalsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]
  before_filter :authenticate_parents,  :only => [ :index_for_parent ]
  before_filter :authenticate_pupils,   :only => [ :index_for_pupil ]
  before_filter :authenticate_class_heads, :only => [ :index_class_head ]

  def index_class_head
    @school_class = get_class( current_user ); @subjects_of_class = []; @show_journal = false
    @pupils = []; @lessons = []; @lessons_exist = false; @pupils_exist = false;

    unless @school_class.nil?
      @subjects_of_class = get_subjects_for_class( @school_class )

      if params.has_key?( :s_id )                                                         # If user chose subject.
        @subject = Subject.where( "id = ?", params[:s_id] ).first

        if current_user.teacher_leader.teacher.subject_ids.include? @subject.id
          @show_journal = true

          @lessons = lessons_for_school_class( @school_class )                               # Lessons of class.
          @lessons_exist = @lessons.first ? true : false

          @pupils = get_pupils_for_class( @school_class )                                   # Pupils in the class.
          @pupils_exist = @pupils.first ? true : false
        end
      end
    end
  end

  def index_for_pupil
    @pupil = current_user.pupil; @pupil_curriculums_exist = false
    @pupil_lessons_exist = false

    unless @pupil.school_class.nil?                                                       # If pupil has his school class.
      @pupil_curriculums = curriculums_for_pupil( @pupil )
      @pupil_curriculums_exist = @pupil_curriculums.first ? true : false

      if params.has_key?( :curr_id )                                                      # If pupil chose subject.
        curriculum = Curriculum.where( "id = ?", params[:curr_id] ).first

        @choosen_subject = curriculum.qualification.subject                               # Choosen lesson from dropdown menu.

        @pupil_lessons = lessons_for_one_curriculum( curriculum )
        @pupil_lessons_exist = @pupil_lessons.first ? true : false
      end
    end
  end

  def index_for_parent
    @pupil = nil; @pupil_curriculums_exist = false; @pupil_lessons_exist = false

    if params.has_key?( :p_id )                                                           # If parent chose his pupil.
      @pupil = Pupil.where( "id = ?", params[:p_id] ).first

      if current_user.parent.pupil_ids.include? @pupil.id #and @pupil.school_class.nil?    # If chosen pupil is child of parent and pupil has his class.
        @pupil_curriculums = curriculums_for_pupil( @pupil )
        @pupil_curriculums_exist = @pupil_curriculums.first ? true : false

        if params.has_key?( :curr_id )                                                    # If parent chose subject.
          curriculum = Curriculum.where( "id = ?", params[:curr_id] ).first

          @choosen_subject = curriculum.qualification.subject                             # Choosen lesson from dropdown menu.

          @pupil_lessons = lessons_for_one_curriculum( curriculum )
          @pupil_lessons_exist = @pupil_lessons.first ? true : false
        end
      end
    end
  end

  def index
    @subject = []; @pupils = []; @lessons_exist = false; @pupils_exist = false;
    @show_journal = false

    @teacher_subjects = current_user.teacher.subjects                                     # This we get when user choose subject from toolbar.
    @classes = SchoolClass.all
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )

    if params.has_key?( :subject_name )
      if current_user.teacher.subject_ids.include?( @subject.id )
        @show_journal = true
        @lessons = teacher_lessons_dates( current_user.teacher, @subject, @school_class ) # Lessons of teacher.
        @lessons_exist = @lessons.first ? true : false

        @pupils = get_pupils_for_class( @school_class )                                   # Pupils in the class.
        @pupils_exist = @pupils.first ? true : false
      end
    end
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

    # Collecting all subjects for class.
    # Return Array.
    # => [] if no subjects founded.
    def get_subjects_for_class( school_class )
      out = []; curriculums = []
      curriculums = school_class.curriculums

      unless curriculums.empty?
        qualifications = curriculums.collect{ |c| c.qualification }

        unless qualifications.empty?
          out = qualifications.collect{ |q| q.subject  }
        end
      end

      if out.empty?
        out
      else
        out.flatten
      end
    end

    # Collecting all lessons for class.
    # Return Array.
    # => [] if no lessons founded.
    def lessons_for_school_class( school_class )
      out = []; curriculums = []; curriculums = school_class.curriculums

      unless curriculums.empty?
        timetables = curriculums.collect{ |c| c.timetables }.flatten

        unless timetables.empty?
          out = timetables.collect{ |t| t.lessons }.flatten
        end
      end

      if out.empty?
        out
      else
        out.flatten
      end
    end
end
