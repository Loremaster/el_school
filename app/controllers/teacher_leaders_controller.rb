# encoding: UTF-8
class TeacherLeadersController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :new, :create ] 
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @user = User.new
    @teacher_leader = @user.build_teacher_leader
    
    
    @teachers_collection = Teacher.all                                                    # Collect array of ["teacher names", teacher.id] which are options of select in view.
                                  .collect do |t| 
                                    [ "#{t.teacher_last_name} #{t.teacher_first_name} #{t.teacher_middle_name}", t.id ] 
                                   end
    # @teachers_collection = [] #Just to test
    @choosen_teacher = @teachers_collection.first.last unless @teachers_collection.empty? # First array, then last element in array. Get it ONLY if we've found teachers.
  end
   
  def create
    if ( params.has_key?( :teacher_id ) )
      user = User.new( params[:user] )
      user.user_role = "class_head"
    
      if user.save
        flash[:success] = "Классный руководитель успешно создан!"
        redirect_to teachers_path
      else
        flash[:error] = user.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                              :two_words_connector => ", "
        redirect_to new_teacher_leader_path
      end
    else
      flash[:error] = "К сожалению, невозможно создать классного руководителя. " +
                      "Администратор должен создайть хотя бы одного учителя."
      redirect_to new_teacher_leader_path    
    end    
  end
end
