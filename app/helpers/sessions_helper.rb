# encoding: UTF-8
module SessionsHelper
  def redirect_back_to_user_page                                                          # Redirecting user to his pages.
    if nil?                                                                               # If not autorized user.
      redirect_back_or signin_path
    else
      if signed_in? and current_user_admin?
        redirect_back_or users_path
      end
      if signed_in? and current_user_school_head?
        redirect_back_or pupils_path
      end
      if signed_in? and current_user_class_head?
        redirect_back_or events_path
      end
      if signed_in? and current_user_teacher?
        redirect_back_or journals_path
      end
      if signed_in? and current_user_parent?
        redirect_back_or meetings_show_parent_path
      end
    end
  end

  def sign_in( user )
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]                      # Creating secure remember token associated with the User model to be used in place of the user id.
    @current_user = user
  end

  def sign_out
    cookies.delete(:remember_token)
    @current_user = nil
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def authenticate
    deny_access unless signed_in?
  end

  def current_user_admin?
    current_user.user_role == "admin"
  end

  def current_user_school_head?
    current_user.user_role == "school_head"
  end

  def current_user_class_head?
    current_user.user_role == "class_head"
  end

  def current_user_teacher?
    current_user.user_role == "teacher"
  end

  def current_user_parent?
    current_user.user_role == "parent"
  end

  def authenticate_admins
    deny_access_except_admins unless ( signed_in? and current_user_admin? )
  end

  def authenticate_school_heads
    deny_access_except_school_heads unless ( signed_in? and current_user_school_head? )
  end

  def authenticate_class_heads
    deny_access_except_class_heads unless ( signed_in? and current_user_class_head? )
  end

  def authenticate_teachers
    deny_access_except_teachers unless ( signed_in? and current_user_teacher?  )
  end

  def authenticate_parents
    deny_access_except_parents unless ( signed_in? and current_user_parent? )
  end

  def deny_access
    store_location
    redirect_to signin_path,
                :notice => "Пожалуйста, войдите в систему, чтобы увидеть эту страницу."   # Here :notice is "flash[:notice]".
  end

  def deny_access_except_admins
    store_location
    if signed_in?
      redirect_to pages_wrong_page_path,
                  :flash => { :error => "К сожалению, вы не можете увидеть эту страницу." }
    else
      redirect_to signin_path,
                  :notice => "Пожалуйста, войдите в систему как администратор, чтобы увидеть эту страницу."
    end
  end

  def deny_access_except_school_heads
    store_location
    if signed_in?
      redirect_to pages_wrong_page_path,
                  :flash => { :error => "К сожалению, вы не можете увидеть эту страницу." }
    else
      redirect_to signin_path,
                  :notice => "Пожалуйста, войдите в систему как Завуч, чтобы увидеть эту страницу."
    end
  end

  def deny_access_except_class_heads
    store_location
    if signed_in?
      redirect_to pages_wrong_page_path,
                  :flash => { :error => "К сожалению, вы не можете увидеть эту страницу." }
    else
      redirect_to signin_path,
                  :notice => "Пожалуйста, войдите в систему как Классный руководитель, чтобы увидеть эту страницу."
    end
  end

  def deny_access_except_teachers
    store_location
    if signed_in?
      redirect_to pages_wrong_page_path,
                  :flash => { :error => "К сожалению, вы не можете увидеть эту страницу." }
    else
      redirect_to signin_path,
                  :notice => "Пожалуйста, войдите в систему как Учитель, чтобы увидеть эту страницу."
    end
  end

  def deny_access_except_parents
    store_location
    if signed_in?
      redirect_to pages_wrong_page_path,
                  :flash => { :error => "К сожалению, вы не можете увидеть эту страницу." }
    else
      redirect_to signin_path,
                  :notice => "Пожалуйста, войдите в систему как Родитель, чтобы увидеть эту страницу."
    end
  end

  def redirect_back_or( default )
      redirect_to( session[:return_to] || default )
      clear_return_to
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end
end
