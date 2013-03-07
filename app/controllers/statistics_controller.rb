class StatisticsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index_teacher ]
  before_filter :authenticate_class_heads, :only => [ :index_class_head ]

  def index_teacher
    @subject = params[:subject_name]
    @classes = current_user.teacher.classes
    @class   = current_user.teacher.current_class( params[:class_code] )
    @pupils  = @class.pupils unless @class.nil?                                                     # Search pupils if class exists only.
  end

  def index_class_head
    @subject = params[:subject_name]
    @school_class = current_user.teacher_leader.school_class
  end
end
