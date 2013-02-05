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
    @reporting = @lesson.reporting
    @attendance = Attendance.new
    @estimation = Estimation.new
  end

  def create
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupil = $pupil; @lesson = $lesson
    @reporting = @lesson.reporting
    @attendance = Attendance.new( params[:attendance] )
    @estimation = Estimation.new( params[:estimation] )

    # Save objects if no errors founded.
    if @attendance.valid? and @estimation.valid?
      @attendance.save
      @estimation.save

      flash[:success] = "Данные успешно созданы!"
      redirect_to journals_path( :class_code => params[:class_code], :subject_name => params[:subject_name] )
    else
      render 'new'
    end
  end

  def edit
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    pupil = get_pupil_from_params( params ); $pupil = pupil
    lesson = get_lesson_from_params( params ); $lesson = lesson
    @pupil = $pupil; @lesson = $lesson
    @reporting = @lesson.reporting
    @attendance = Attendance.find( params[:id] )
    @estimation = estimation_of_pupil_from_lesson( @lesson, @pupil.id )
  end

  def update
    @teacher_subjects = current_user.teacher.subjects
    @subject, school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupil = $pupil; @lesson = $lesson
    @reporting = @lesson.reporting
    @attendance = Attendance.find( params[:id] )
    @estimation = estimation_of_pupil_from_lesson( @lesson, @pupil.id )

    temp_att = Attendance.new( params[:attendance] )                                                # Hack to test that new objects will valid, so we can
    temp_est = Estimation.new( params[:estimation] )                                                # update them and show all errors.

    if temp_att.valid? and temp_est.valid?
      @attendance.update_attributes( params[:attendance] )
      @estimation.update_attributes( params[:estimation] )

      flash[:success] = "Данные успешно обновлены!"
      redirect_to journals_path( :class_code => params[:class_code], :subject_name => params[:subject_name] )
    else
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
end
