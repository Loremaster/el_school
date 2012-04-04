# encoding: UTF-8
class TeacherLeadersController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :new, :create ] 
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @user = User.new
    # @teacher_leader = @user.build_teacher_leader
    
    
    @teachers_collection = Teacher.all                                                    # Collect array of ["teacher names", teacher.id] which are options of select in view.
                                  .collect do |t| 
                                    [ "#{t.teacher_last_name} #{t.teacher_first_name} #{t.teacher_middle_name}", t.id ] 
                                   end
    # @teachers_collection = []
    @choosen_teacher = @teachers_collection.first.last unless @teachers_collection.empty? # First array, then last element in array. Get it ONLY if we've found teachers.
  end
   
  def create
    t, errors = nil, nil
    
    if ( params.has_key?( :teacher_id ) )
      user = User.new( params[:user] )
      user.user_role = "class_head"
      
      if user.save
         t = TeacherLeader.new( :teacher_id => params[:teacher_id], :user_id => user.id )
         
         if t.save
           redirect_to teachers_path
           flash[:success] = "Классный руководитель успешно создан!"
         else
           errors = t.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                       :two_words_connector => ", "
           user.destroy
         end 
      else
        errors = user.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                       :two_words_connector => ", "
            
      end
    else
      errors = "К сожалениею, невозможно создать классного руководителя." +
                      "Пожалуйста, создайте сначала учителя."
    end
    
    if not errors.nil? 
      redirect_to new_teacher_leader_path
      flash[:error] = errors
    end  
    
  end
end
