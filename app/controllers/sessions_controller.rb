# encoding: UTF-8

class SessionsController < ApplicationController
  def new                                                                     #Sign in page
    redirect_back_to_user_page                                                #Check who user is and redirect him to his page(s).
  end

  def create
    user = User.authenticate(params[:session][:user_login],
                             params[:session][:password])
    if user.nil?
      flash.now[:error] = "Не удается войти. Пожалуйста, проверьте правильность написания логина и пароля. "\
                          "Проверьте, не нажата ли клавиша CAPS-lock."
      render 'new'
    else
      sign_in user                                                            #Signing in user, giving him cookies and etc
      #redirect_to user
      redirect_back_to_user_page                                              #Check who user is and redirect him to his page(s).
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
