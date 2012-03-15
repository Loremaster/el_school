# encoding: UTF-8
class AdminsController < ApplicationController
  before_filter :authenticate_admins, :only => [ :backups,
                                                 :users_of_system,
                                                 :new_school_head,
                                                 :new_teacher,
                                                 :create_school_head ]

  def backups
  end

  def users_of_system
    @all_users = User.all
  end

  def new_school_head
    @user = User.new
  end

  def create_school_head
    user = User.new(params[:user])
    user.user_role = "school_head"

    if user.save
      redirect_to admins_users_of_system_path
      flash[:success] = "Завуч успешно создан!"
    else
      redirect_to admins_new_school_head_path
      flash[:error] = user.errors.full_messages.to_sentence :last_word_connector => ", ",
                                                            :two_words_connector => ", "
    end
  end

  def new_teacher
    @user = User.new
    teacher = @user.build_teacher
  end

  #TODO Add Data testing - format, dd.mm.yyyy in field and etc.
  #TODO test ingration, that create_school_head works.
  #TODO test that create_teacher works.
  #TODO keep data in worms while redirecting.
  
  def create_teacher
    user_errors = nil 
  
    user = User.new( params[:user] )
    user.user_role = "teacher"
    user.teacher.user_id = current_user.id                                                #Set this manually because teacher need this.
    
    if user.save
      redirect_to admins_users_of_system_path
      flash[:success] = "Teacher created!"
    else
      redirect_to admins_new_teacher_path
      user_errors = user.errors.full_messages.to_sentence :last_word_connector => ", ",
                                                          :two_words_connector => ", "
      flash[:error] = user_errors if user_errors.present?
    end 
  end

  
  
  # def create_teacher
  #    params[:user][:user_role] = "teacher"      
  #    user = User.new(params[:user])
  #  
  #    if user.save
  #      teacher = user.build_teacher( params[:user][:teacher_attributes] )
  #      if teacher.valid?
  #        teacher.save
  #        redirect_to admins_users_of_system_path
  #        flash[:success] = "Teacher created!"
  #      else
  #        redirect_to admins_new_teacher_path
  #        flash[:error] = teacher.errors.full_messages.to_sentence
  #        user.destroy
  #      end
  #    else
  #      redirect_to admins_new_teacher_path
  #      flash[:error] = user.errors.full_messages.to_sentence
  #       # flash[:notice] = user.teacher.errors.full_messages.to_sentence
  #    end
  #  end
end
