class JournalsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]

  def index
    @subject = []
    @teacher_subjects = current_user.teacher.subjects
    @subject = Subject.where( "subject_name = ?", params[:subject_name] )                 # This we get when user choose subject from toolbar.
    @classes = SchoolClass.all
  end

  private

end
