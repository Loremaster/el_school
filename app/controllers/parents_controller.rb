# encoding: UTF-8
class ParentsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create, :edit,
                                                       :update ]

  def index
    @parent_exist = Parent.first ? true : false
    @parents = Parent.order( :parent_last_name, :parent_first_name, :parent_middle_name )
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
      flash.now[:error] = @parent.errors.full_messages
                                        .to_sentence :last_word_connector => ", ",
                                                     :two_words_connector => ", "
      render "new"
    end
  end

  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @parent = Parent.find( params[:id] )
  end

  def update
    @everpresent_field_placeholder = "Обязательное поле"
    @parent = Parent.find( params[:id] )

    if @parent.update_attributes( params[:parent] )
      redirect_to parents_path
      flash[:success] = "Родитель успешно обновлен!"
    else
      flash.now[:error] = @parent.errors.full_messages
                                        .to_sentence :last_word_connector => ", ",
                                                     :two_words_connector => ", "
      render 'edit'                                                                       # After calling this we get all from params. That means that fields are not autocomplete if user edited them.
    end
  end
end
