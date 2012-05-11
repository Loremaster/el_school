class JournalsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]

  def index
    @teacher_subjects = current_user.teacher.subjects
    flash[:notice] = "#{@teacher_subjects.inspect}"
  end
end
