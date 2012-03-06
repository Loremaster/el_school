module SessionsHelper
  def sign_in( user )
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]          #Creating secure remember token associated with the User model to be used in place of the user id
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

  #def admin?
  #  u = current_user
  #  u.role == "admin"
  #end
  #
  #def authenticate_admins
  #  deny_access_except_admins unless ( signed_in? and admin? )
  #end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page." #here :notice is "flash[:notice]"
  end

  #def deny_access_except_admins
  #  store_location
  #  redirect_to signin_path, :notice => "Please sign in as admin to access this page." #here :notice is "flash[:notice]"
  #end

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
