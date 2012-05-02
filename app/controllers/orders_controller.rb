# encoding: UTF-8
class OrdersController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create, :edit, 
                                                       :update ]
  
  def index
    @orders = Order.all
    @orders_exist = Order.first ? true : false                                            # Order.first generates nil if there are no entrys.
  end
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @order = Order.new
  end
  
  def create
    @everpresent_field_placeholder = "Обязательное поле"
    @choosen_class = params[:order][:school_class_id]                                     # After submit if get errors we use this method and render template for this.
    @choosen_pupil = params[:order][:pupil_id]                                            # We save this param because rails doesn't auomatically select from selectors.
    @order = Order.new( params[:order] )
    
    if @order.save
      redirect_to orders_path
      flash[:success] = "Приказ успешно создан!" 
    else
      flash.now[:error] = @order.errors.full_messages
                                      .to_sentence :last_word_connector => ", ",        
                                                   :two_words_connector => ", "
      render 'new'                                                                        # It should be placed after flash message or you will have to click button twice.
    end
  end
  
  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @order = Order.find( params[:id] )    
  end
  
  def update
    @everpresent_field_placeholder = "Обязательное поле"
    @order = Order.find( params[:id] )
    
    if @order.update_attributes( params[:order] )
      redirect_to orders_path
      flash[:success] = "Приказ успешно обновлен!"
    else
      flash.now[:error] = @order.errors.full_messages
                                       .to_sentence :last_word_connector => ", ",        
                                                    :two_words_connector => ", "
      render 'edit'                                                                       # After calling this we get all from params. That meand that fields are not autocomplete if user edited them.
    end
  end
end
