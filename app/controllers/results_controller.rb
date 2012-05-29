# encoding: UTF-8
class ResultsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index, :new, :create ]

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

  private
    def get_pupil_from_params( params )
      Pupil.where( "id = ?", params[:p_id] ).first
    end
end
