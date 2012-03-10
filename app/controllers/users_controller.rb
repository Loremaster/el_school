class UsersController < ApplicationController
  before_filter :authenticate, :only => [:new, :create, :show]

  def new
  end

  def create
    # @user = User.new(params[:user])
    # if @user.save
    #   sign_in @user
    #   flash[:success] = "Welcome to the Sample App!"
    #   redirect_to @user
    # else
    #   @title = "Sign up"
    #   render 'new'
    # end
  end

  def show

  end

end
