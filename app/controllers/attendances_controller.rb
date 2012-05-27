# encoding: UTF-8
class AttendancesController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :new, :create, :edit, :update ]

  def new
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    pupil = get_pupil_from_params( params ); $pupil = pupil
    lesson = get_lesson_from_params( params ); $lesson = lesson
    @pupil = $pupil; @lesson = $lesson                                                    # Using global value to save object from params.
    @report_types = collect_report_types
    @reporting = @lesson.reporting; @nominals = collect_nominals
    @choosen_nominal = nil                                                                # It is first empty value in list.
    @attendance = Attendance.new
    @estimation = Estimation.new
  end

  def create
    errors_messages = []
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupil = $pupil; @lesson = $lesson
    @reporting = @lesson.reporting; @nominals = collect_nominals
    @choosen_nominal = params[:estimation][:nominal]
    @attendance = Attendance.new( params[:attendance] )
    @estimation = Estimation.new( params[:estimation] )

    # Adding errors to array of errors for each object that we want to save.
    unless @attendance.valid?
      errors_messages << @attendance.errors.full_messages.to_sentence
    end

    unless @estimation.valid?
      errors_messages << @estimation.errors.full_messages.to_sentence
    end

    # Save objects if no errors founded.
    if errors_messages.empty?
      @attendance.save; @estimation.save
      redirect_to journals_path( :class_code => params[:class_code],
                                 :subject_name => params[:subject_name] )
      flash[:success] = "Данные успешно созданы!"
    else
      flash.now[:error] = get_clear_error_message( errors_messages )
      render 'new'
    end
  end

  def edit
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    pupil = get_pupil_from_params( params ); $pupil = pupil
    lesson = get_lesson_from_params( params ); $lesson = lesson
    @pupil = $pupil; @lesson = $lesson
    @reporting = @lesson.reporting; @nominals = collect_nominals
    @attendance = Attendance.find( params[:id] )
    @estimation = estimation_of_pupil_from_lesson( @lesson, @pupil.id )
    @choosen_nominal = @estimation.nominal
  end

  def update
    errors_messages = []
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupil = $pupil; @lesson = $lesson
    @reporting = @lesson.reporting; @nominals = collect_nominals
    @attendance = Attendance.find( params[:id] )
    @estimation = estimation_of_pupil_from_lesson( @lesson, @pupil.id )
    @choosen_nominal = params[:estimation][:nominal]

    temp_att = Attendance.new( params[:attendance] )                                      # Hack to test that new objects will valid, so we can
    temp_est = Estimation.new( params[:estimation] )                                      # update them and show all errors.

    unless temp_att.valid?
      errors_messages << temp_att.errors.full_messages.to_sentence
    end

    unless temp_est.valid?
      errors_messages << temp_est.errors.full_messages.to_sentence
    end

    # Adding errors to array of errors for each object that we want to save.
    if errors_messages.empty?
      @attendance.update_attributes( params[:attendance] )
      @estimation.update_attributes( params[:estimation] )
      redirect_to journals_path( :class_code => params[:class_code],
                                 :subject_name => params[:subject_name] )
      flash[:success] = "Данные успешно обновлены!"
    else
      flash.now[:error] = get_clear_error_message( errors_messages )
      render 'edit'
    end
  end

  private

    def get_pupil_from_params( params )
      Pupil.where( "id = ?", params[:p_id] ).first
    end

    def get_lesson_from_params( params )
      Lesson.where("id = ?", params[:lesson_id] ).first
    end

    # Removing "and" from error message with russians words.
    def get_clear_error_message( errors_messages )
      out = errors_messages.to_sentence :last_word_connector => ", ",:two_words_connector => ", "
      out.gsub(" and", " ")                                                               # Removing "and" and put there " ".
    end
end
