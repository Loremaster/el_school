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
                                   
    @choosen_teacher = @teachers_collection.first.last unless @teachers_collection.empty? # First array, then last element in array. Get it ONLY if we've found teachers.
  end
   
  def create
    errors = nil
    teachers_existance = params[:user][:teacher_leader_attributes]
    
    if not teachers_existance.nil?                                                        # If we have teachers.
      user = User.new( params[:user] )
      user.user_role = "class_head"
    
      if user.save
        flash[:success] = "Классный руководитель успешно создан!"
        redirect_to teachers_path
      else
        errors = user.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                       :two_words_connector => ", "
      end
    else
      errors = "К сожалению, невозможно создать классного руководителя. " +
               "Администратор должен создать хотя бы одного учителя." 
    end
    
    if not errors.nil?
      flash[:error] = "#{errors}"
      redirect_to new_teacher_leader_path( params ) 
    end    
  end
end
