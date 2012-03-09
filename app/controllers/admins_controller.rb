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
      flash[:success] = "Завуч успешно создан!"
      redirect_to admins_users_of_system_path
    else
      flash[:error] = "Не удалось создать завуча!"
      redirect_to admins_users_of_system_path
    end
  end


  def new_teacher
  end
end
