class ResultsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index, :new, :create ]

  def index
    @subject = []; @pupils = []
    @classes = SchoolClass.all
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupils = get_pupils_for_class( @school_class )                                       # Pupils in the class.
    @pupils_exist = @pupils.first ? true : false
  end

  def new
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    $pupil = get_pupil_from_params( params ); @pupil = $pupil
    @result = Result.new
  end

  def create

  end

  private
    def get_pupil_from_params( params )
      Pupil.where( "id = ?", params[:p_id] ).first
    end
end
