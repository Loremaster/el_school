class TeachersController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :edit, :update ]
  
  #TODO test that teacher name appear here.
  def index
    @teachers = Teacher.all
  end
  
  def edit
    @teacher = Teacher.find( params[:id] )
    flash[:notice] = "#{@teacher.inspect}"
  end
  
  def update
    @teacher = Teacher.find( params[:id] )
    if @teacher.update_attributes(params[:teacher])
      # redirect_to teachers_path
      flash[:success] = "Successfully updated subjects for teacher!"
    else
      # redirect_to edit_teacher_path
      flash[:error] = "Subjects for teacher was not updated!"
    end
  end
end
