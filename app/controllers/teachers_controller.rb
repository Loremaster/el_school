# encoding: UTF-8
class TeachersController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :edit, :update ]

  #TODO test that teacher name appear here.
  def index
    @teachers = Teacher.order( :teacher_last_name, :teacher_first_name,
                               :teacher_middle_name )
    @teachers_leaders = TeacherLeader.joins(:teacher)
                                     .order( :teacher_last_name,                          # Sorting teachers for teacher leader by last and first names.
                                             :teacher_first_name,
                                             :teacher_middle_name )
    @teachers_exist = Teacher.first ? true : false                                        # Teacher.first generates nil if there are no entrys.
  end

  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @teacher = Teacher.find( params[:id] )
    @subjects = Subject.order( :subject_name )
  end

  def update
    @everpresent_field_placeholder = "Обязательное поле"
    @teacher = Teacher.find( params[:id] )
    @subjects = Subject.order( :subject_name )

    if @teacher.update_attributes(params[:teacher])
      redirect_to teachers_path
      flash[:success] = "Учитель успешно обновлен!"
    else
      flash.now[:error] = @teacher.errors.full_messages
                                         .to_sentence :last_word_connector => ", ",
                                                      :two_words_connector => ", "
      render "edit"
    end
  end
end
