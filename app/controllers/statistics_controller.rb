class StatisticsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index_teacher ]

  def index_teacher
    @subject = params[:subject_name]
    @classes = current_user.teacher.classes
  end
end
