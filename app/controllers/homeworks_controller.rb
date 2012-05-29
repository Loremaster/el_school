# encoding: UTF-8
class HomeworksController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]

  def index
    @subject = []; @pupils = []; @classes = SchoolClass.all
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
  end
end
