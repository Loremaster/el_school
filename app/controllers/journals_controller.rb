class JournalsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]

  def index
    @teacher_subjects = current_user.teacher.subjects
    subject = Subject.where( "subject_name = ?", params[:subject_name] )                  # This we get when user choose subject from toolbar.
    @classes = SchoolClass.all
    # flash.now[:notice] = "#{subject.inspect}"
  end
end
