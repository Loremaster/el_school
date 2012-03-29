# encoding: UTF-8
class UsersController < ApplicationController
  before_filter :authenticate_admins, :only => [ :index, :edit, :update ]
  
  # List of all users in system.
  def index
    @all_users = User.all
  end
  
  # Editing user with forms.
  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @user = User.find( params[:id] )
  end
  
  # Updating user via fresh data from 'edit'.
  def update
    @user = User.find( params[:id] )
    
    if @user.update_attributes( params[:user] )
       redirect_to users_path
       flash[:success] = "Пользователь успешно обновлен!"
    else
       redirect_to edit_user_path
       flash[:error] = @user.errors.full_messages.to_sentence :last_word_connector => ", ",
                                                              :two_words_connector => ", "
    end
  end
end
