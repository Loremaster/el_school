# encoding: UTF-8
class LessonsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :new, :create ]

  def new
    @teacher_subjects = current_user.teacher.subjects
    subject = Subject.where( "subject_name = ?", params[:subject_name] ).first
    school_class = SchoolClass.where( "class_code = ?", params[:class_code] )
    timetables = timetables_for_teacher_with_subject( current_user.teacher, subject.subject_name )
    @timetables_collection = timetables_for_select_list( timetables )

    @lesson = Lesson.new
    @everpresent_field_placeholder = "Обязательное поле"

    flash[:notice] = "#{@timetables_collection}"
  end

  def create
    @teacher_subjects = current_user.teacher.subjects
    @everpresent_field_placeholder = "Обязательное поле"
    subject = Subject.where( "subject_name = ?", params[:subject_name] ).first
    timetables = timetables_for_teacher_with_subject( current_user.teacher, subject.subject_name )
    @timetables_collection = timetables_for_select_list( timetables )

    @lesson = Lesson.new( params[:lesson] )

    if @lesson.update_attributes( params[:lesson] )
      redirect_to journals_path( :class_code => params[:class_code],
	                               :subject_name => params[:subject_name] )
      flash[:success] = "Дата успешно создана!"
    else
      flash.now[:error] = @lesson.errors.full_messages
                                        .to_sentence :last_word_connector => ", ",
                                                     :two_words_connector => ", "
      render 'new'
    end
  end

  private

    # Get ALL timetables for teacher
    # => Array
    def timetables_for_teacher_with_subject( teacher, subject_name )
      tt = []                                                                             # Output timetables
      subject = teacher.subjects.where(:subject_name => subject_name).first               # Get subject for teacher.
      subject_qualification = teacher.qualifications.where(:subject_id => subject.id).first # Qualification for subject.
      curriculums = subject_qualification.curriculums                                     # Get all curriculums
      curriculums.each { |c| tt << c.timetables  }                                        # Collecting all timetables.
      tt.flatten!                                                                         # To 1 dimension array (because of many-to-one).
    end

    # Retutn all timetables for timetable.
    # Input timetable should be array!
    # => Array
    def timetables_for_select_list( timetables )
      raise TypeError, "Input timetables should be Array!" unless timetables.kind_of?(Array) # It is REALLY important to be array.

      timetables.collect do |tt|
        ["#{translate_day_of_week(tt.tt_day_of_week)} - #{tt.tt_number_of_lesson}й урок", tt.id]
      end
    end
end
