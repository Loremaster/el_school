# encoding: UTF-8
class TeachersController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :edit, :update ]
  
  #TODO test that teacher name appear here.
  def index
    @teachers = Teacher.all
    @teachers_leaders = TeacherLeader.all
  end
  
  def edit
    @teacher = Teacher.find( params[:id] )
  end
  
  def update
    @teacher = Teacher.find( params[:id] )
    if @teacher.update_attributes(params[:teacher])
      redirect_to teachers_path
      flash[:success] = "Предметы учителя успешно обновлены!"
    else
      redirect_to edit_teacher_path
      flash[:error] = "Не удалось обновить предметы для учителя! Пожалуйста, попробуйте еще раз!"
    end
  end
end
