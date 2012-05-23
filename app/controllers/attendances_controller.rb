# encoding: UTF-8
class AttendancesController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :new, :create, :edit, :update ]

  def new
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    pupil = get_pupil_from_params( params ); $pupil = pupil
    lesson = get_lesson_from_params( params ); $lesson = lesson
    @pupil = $pupil; @lesson = $lesson                                                    # Using global value to save object from params.
    @attendance = Attendance.new
    @report_types = collect_report_types
  end

  def create
    errors_messages = []
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupil = $pupil; @lesson = $lesson
    @attendance = Attendance.new( params[:attendance] )

    if @attendance.update_attributes( params[:attendance] )
      redirect_to journals_path( :class_code => params[:class_code],
                                 :subject_name => params[:subject_name] )
      flash[:success] = "Данные успешно обновлены!"
    else
      flash.now[:error] = @attendance.errors.full_messages
                                     .to_sentence :last_word_connector => ", ",
                                                  :two_words_connector => ", "
      render 'edit'
    end

    # @reporting = Reporting.new( params[:reporting] )
    # @report_types = collect_report_types
    #
    # # Adding errors to array of errors for each object that we want to save.
    # unless @attendance.valid?
    #   errors_messages << @attendance.errors.full_messages.to_sentence
    # end
    #
    # unless @reporting.valid?
    #   errors_messages << @reporting.errors.full_messages.to_sentence
    # end
    #
    # # Save objects if no errors founded.
    # if errors_messages.empty?
    #     @attendance.save; @reporting.save
    #     redirect_to journals_path( :class_code => params[:class_code],
    #                                :subject_name => params[:subject_name] )
    #     flash[:success] = "Данные успешно созданы!"
    # else
    #   flash.now[:error] = get_clear_error_message( errors_messages )
    #   render 'new'
    # end
  end

  def edit
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    pupil = get_pupil_from_params( params ); $pupil = pupil
    lesson = get_lesson_from_params( params ); $lesson = lesson
    @pupil = $pupil; @lesson = $lesson
    @attendance = Attendance.find( params[:id] )
  end

  def update
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupil = $pupil; @lesson = $lesson
    @attendance = Attendance.find( params[:id] )

    if @attendance.update_attributes( params[:attendance] )
      redirect_to journals_path( :class_code => params[:class_code],
	                               :subject_name => params[:subject_name] )
      flash[:success] = "Данные успешно обновлены!"
    else
      flash.now[:error] = @attendance.errors.full_messages
                                     .to_sentence :last_word_connector => ", ",
                                                  :two_words_connector => ", "
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
