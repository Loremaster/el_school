class StatisticsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index_teacher ]

  def index_teacher
    @subject = params[:subject_name]
    @classes = current_user.teacher.classes
    @class   = current_user.teacher.current_class( params[:class_code] )
    @pupils  = @class.pupils unless @class.nil?                                                     # Search pupils if class exists only.
  end
end
