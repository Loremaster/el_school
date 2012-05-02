# encoding: UTF-8
class UsersController < ApplicationController
  before_filter :authenticate_admins, :only => [ :index, :edit, :update ]
  
  # List of all users in system.
  def index
    @users = User.all
  end
  
  # Editing user with forms.
  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @user = User.find( params[:id] )
  end
  
  # Updating user via fresh data from 'edit'.
  def update
    @everpresent_field_placeholder = "Обязательное поле"
    @user = User.find( params[:id] )
    
    if @user.update_attributes( params[:user] )
       redirect_to users_path
       flash[:success] = "Пользователь успешно обновлен!"
    else
       flash.now[:error] = @user.errors.full_messages
                                       .to_sentence :last_word_connector => ", ",
                                                    :two_words_connector => ", "
       render "edit"                                                       
    end
  end
end
