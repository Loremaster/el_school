# encoding: UTF-8
class TeacherLeadersController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :new, :create, :edit, :update ] 
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"; @login, @password = "", ""        
    @teachers_collection = collect_teachers                         
    @choosen_teacher = @teachers_collection.first.last unless @teachers_collection.empty? # First array, then last element in array. Get it ONLY if we've found teachers.
    @user = User.new
    @teacher_leader = @user.build_teacher_leader
    
    # Saving values from params if we receive them
    if params.has_key?( :user )
      @login    = params[:user][:user_login]
      @password = params[:user][:password]
      @choosen_teacher = params[:user][:teacher_leader_attributes][:teacher_id] if params[:user].has_key?( :teacher_leader_attributes )
    end
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
  
  def edit
    @teacher_leader = TeacherLeader.find( params[:id] )    
    @teachers_collection = collect_teachers
    @choosen_teacher = @teacher_leader.teacher_id
  end
  
  def update
    @teacher_leader = TeacherLeader.find( params[:id] )
    @choosen_teacher_id_by_user = params[:teacher_leader][:teacher_id].to_i

    if not Teacher.all.empty?
      if ( @teacher_leader.teacher_id != @choosen_teacher_id_by_user )  and               # Is current teacher not already leader?
         ( @teacher_leader.update_attributes( params[:teacher_leader] ) )                 # Do we get valid data so we can update?
        redirect_to teachers_path
        flash[:success] = "Классный руководитель успешно обновлен!"
      else
        redirect_to edit_teacher_leader_path
        if @teacher_leader.errors.empty?
          flash[:error] = "Выбранный учитель уже является классным руководителем!"        # We show this only if we want to update current choosen teacher who ALREADY is leader.
        else
          flash[:error] = @teacher_leader.errors.full_messages.to_sentence :last_word_connector => ", ", 
                                                                           :two_words_connector => ", "
        end      
      end
    else
      flash[:error] = "Невозможно обновить классного руководителя." +
                      "Пожалуйста, сначала добавьте хотя бы одного учителя!"
    end  
  end
  
  private 
  
    # Collect array of ["teacher names", teacher.id] which are options of select in view.
    def collect_teachers
      Teacher.all.collect do |t| 
       [ "#{t.teacher_last_name} #{t.teacher_first_name} #{t.teacher_middle_name}", t.id ] 
      end
    end
end

