# encoding: UTF-8
class ResultsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index, :new, :create, :edit, :update ]

  def index
    @subject = []; @pupils = []
    @classes = SchoolClass.all
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupils = get_pupils_for_class( @school_class )                                       # Pupils in the class.
    @pupils_exist = @pupils.first ? true : false
    @teacher = current_user.teacher
  end

  def new
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    $pupil = get_pupil_from_params( params ); @pupil = $pupil; @nominals = collect_nominals
    @curriculum = curriculum_for_teacher_with_subject_and_class( current_user.teacher,
                                                                 @subject.subject_name,
                                                                 @school_class )
    @result = Result.new
  end

  def create
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupil = $pupil; @nominals = collect_nominals
    @curriculum = curriculum_for_teacher_with_subject_and_class( current_user.teacher,
                                                                 @subject.subject_name,
                                                                 @school_class )
    @result = Result.new( params[:result] )

    if @result.save
      redirect_to results_path( :class_code => params[:class_code],
                                :subject_name => params[:subject_name] )
      flash[:success] = "Итоги успешно созданы!"
    else
      flash.now[:error] = @result.errors.full_messages
                                        .to_sentence :last_word_connector => ", ",
                                                     :two_words_connector => ", "
      render 'new'
    end
  end

  def edit
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @nominals = collect_nominals
    @result = Result.find( params[:id] )
  end

  def update
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @nominals = collect_nominals
    @result = Result.find( params[:id] )

    if @result.update_attributes( params[:result] )
      redirect_to results_path( :class_code => params[:class_code],
                                :subject_name => params[:subject_name] )
      flash[:success] = "Итоги успешно обновлены!"
    else
      flash.now[:error] = @result.errors.full_messages
                                        .to_sentence :last_word_connector => ", ",
                                                     :two_words_connector => ", "
      render 'edit'
    end
  end

  private
    def get_pupil_from_params( params )
      Pupil.where( "id = ?", params[:p_id] ).first
    end
end
