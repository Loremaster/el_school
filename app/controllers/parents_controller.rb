# encoding: UTF-8
class ParentsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]

  def index
    @parent_exist = Parent.first ? true : false 
    @parents = Parent.all
  end
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @parent = Parent.new; @user = User.new
  end
  
  def create
    @everpresent_field_placeholder = "Обязательное поле"
    @parent = Parent.new( params[:parent] )
    @parent.user.user_role = "parent"
    
    if @parent.save
      redirect_to parents_path
      flash[:success] = "Родитель успешно создан!"
    else
      flash[:error] = @parent.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                               :two_words_connector => ", "
      render "new"                                                          
    end
  end
end
