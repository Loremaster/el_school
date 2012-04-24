# encoding: UTF-8
class PupilsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create, :edit, 
                                                       :update ]
  
  def index  
    @pupil_exist = Pupil.first ? true : false 
    @pupils = Pupil.order( :pupil_last_name, :pupil_first_name, :pupil_middle_name ) 
    @classes = SchoolClass.order( :class_code )

    if params.has_key?( :class_code )
      unsorted_pupils = SchoolClass.where( "class_code = ?", params[:class_code] )
                                   .first.pupils
      @pupils = unsorted_pupils.order(:pupil_last_name, :pupil_first_name, 
                                      :pupil_middle_name)                              
    end                             
  end
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @pupil_sex_man, @pupil_sex_woman = true, false                                        # Values of radio buttons of sex by default are setting here.       
    @pupil = Pupil.new; @user = User.new; @pupil_phone = PupilPhone.new     
  end
  
  def create
    case params[:pupil][:pupil_sex]
      when 'm' then @pupil_sex_man, @pupil_sex_woman = true, false
      when 'w' then @pupil_sex_man, @pupil_sex_woman = false, true
    end
    
    @login = params[:pupil][:user_attributes][:user_login]
    @password = params[:pupil][:user_attributes][:password]    
    @pupil = Pupil.new( params[:pupil] )
    @pupil.user.user_role = "pupil"
        
    if @pupil.save
      redirect_to pupils_path 
      flash[:success] = "Ученик успешно создан!"
    else
      flash[:error] = @pupil.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                              :two_words_connector => ", "                                                             
      render 'new'
    end
  end
  
  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @pupil = Pupil.find( params[:id] )
     
    case @pupil.pupil_sex
      when 'm' then @pupil_sex_man, @pupil_sex_woman = true, false
      when 'w' then @pupil_sex_man, @pupil_sex_woman = false, true
    end  
  end
  
  def update    
    @pupil = Pupil.find( params[:id] )
    
    case @pupil.pupil_sex
      when 'm' then @pupil_sex_man, @pupil_sex_woman = true, false
      when 'w' then @pupil_sex_man, @pupil_sex_woman = false, true
    end
    
    if @pupil.update_attributes( params[:pupil] )
      redirect_to pupils_path
      flash[:success] = "Ученик успешно обновлен!"
    else
      flash[:error] = @pupil.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                              :two_words_connector => ", "
      render 'edit'
    end
  end
end
