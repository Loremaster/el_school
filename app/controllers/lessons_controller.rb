# encoding: UTF-8
class LessonsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :new, :create, :edit, :update ]

  def new
    @teacher_subjects = current_user.teacher.subjects
    subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    timetables = timetables_for_teacher_with_subject( current_user.teacher,
                                                      subject.subject_name,
                                                      school_class )
    @timetables_collection = timetables_for_select_list( timetables )

    @lesson = Lesson.new
    @everpresent_field_placeholder = "Обязательное поле"
  end

  def create
    @teacher_subjects = current_user.teacher.subjects
    @everpresent_field_placeholder = "Обязательное поле"
    subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    timetables = timetables_for_teacher_with_subject( current_user.teacher,
                                                      subject.subject_name,
                                                      school_class )
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

  def edit
    @teacher_subjects = current_user.teacher.subjects
    @everpresent_field_placeholder = "Обязательное поле"
    subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @lesson = Lesson.find( params[:id] )

    timetables = timetables_for_teacher_with_subject( current_user.teacher,
                                                      subject.subject_name,
                                                      school_class )
    @timetables_collection = timetables_for_select_list( timetables )
  end

  def update
    @teacher_subjects = current_user.teacher.subjects
    @everpresent_field_placeholder = "Обязательное поле"
    subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @lesson = Lesson.find( params[:id] )

    timetables = timetables_for_teacher_with_subject( current_user.teacher,
                                                      subject.subject_name,
                                                      school_class )
    @timetables_collection = timetables_for_select_list( timetables )

    if @lesson.update_attributes( params[:lesson] )
      redirect_to journals_path( :class_code => params[:class_code],
	                               :subject_name => params[:subject_name] )
      flash[:success] = "Урок успешно обновлен!"
    else
      flash.now[:error] = @lesson.errors.full_messages
                                        .to_sentence :last_word_connector => ", ",
                                                     :two_words_connector => ", "
      render 'edit'
    end
  end

  private

    # Retutn all timetables for timetable.
    # Input timetable should be array!
    # => Array
    def timetables_for_select_list( timetables )
      raise TypeError, "Input timetables should be Array!" unless timetables.kind_of?(Array) # It is REALLY important to be array.

      timetables.collect do |tt|
        [ "#{translate_day_of_week(tt.tt_day_of_week)} - #{tt.tt_number_of_lesson}й урок",
          tt.id]
      end
    end
end
