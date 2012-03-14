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
    params[:user][:user_role] = "school_head"
    user = User.new(params[:user])

    if user.save
      redirect_to admins_users_of_system_path
      flash[:success] = "Завуч успешно создан!"
    else
       redirect_to admins_new_school_head_path
       flash[:error] = user.errors
                           .full_messages
                           .to_sentence :last_word_connector => ", ",
                                        :two_words_connector => ", "
    end
  end

  def new_teacher
    @user = User.new
    teacher = @user.build_teacher
  end

  #TODO Add Data testing - format, dd.mm.yyyy in field and etc.
  #TODO Add more talking and clear error messages.
  #TODO Add russian error messages in models.
  

  def create_teacher
    params[:user][:user_role] = "teacher"
    user = User.new(params[:user])
         
    if user.valid?
       user.save
       teacher = user.build_teacher( params[:user][:teacher_attributes] )
       if teacher.valid?
         teacher.save
         redirect_to admins_users_of_system_path
         flash[:success] = "Учитель успешно создан!"
       else
         flash[:error] = "Невозможно создать учителя. Проверьте ваши значения для его данных."
         user.destroy
       end
    else
      flash[:error] = "Невозможно создать пользователя. Невалиден логин и/или пароль."
    end
  end
end
