class ResultsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]

  def index
    @subject = []; @pupils = []
    @classes = SchoolClass.all
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @pupils = get_pupils_for_class( @school_class )                                       # Pupils in the class.
    @pupils_exist = @pupils.first ? true : false
  end
end
