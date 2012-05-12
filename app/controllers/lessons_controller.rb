class LessonsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :new, :create ]

  def new
    @teacher_subjects = current_user.teacher.subjects

  end

  def create

  end
end
