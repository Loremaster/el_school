# encoding: UTF-8

class SessionsController < ApplicationController
  def new                                                                     #Sign in page
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

      #Check who user is and redirect him to his page(s).
      case
        when current_user_admin? == true                                      #If user is admin then redirect him to his page
          redirect_back_or admins_users_of_system_path
        else
          redirect_back_or user
      end
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
