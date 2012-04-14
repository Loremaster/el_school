# encoding: UTF-8
class PupilsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]
  
  def index  
    @pupil_exist = Pupil.first ? true : false 
    @pupils = Pupil.all 
  end
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"; @login, @password = "", ""
    @last_name, @first_name, @middle_name, @birthday, @nationality = "", "", "", "", ""
    @registration, @living, @home_phone, @mobile_phone = "", "", "", "" 
    @pupil_sex_man, @pupil_sex_woman = true, false                                        # Values of radio buttons of sex by default are setting here.       
    @pupil = Pupil.new; @user = User.new; @pupil_phone = PupilPhone.new 
    
    if params.has_key?( :pupil )                                                          # if we redirected back to this method from create (because of new errors).
      @last_name   = params[:pupil][:pupil_last_name]
      @first_name  = params[:pupil][:pupil_first_name]
      @middle_name = params[:pupil][:pupil_middle_name]
      sex          = params[:pupil][:pupil_sex]
      @birthday    = params[:pupil][:pupil_birthday]
      @nationality = params[:pupil][:pupil_nationality]
      @registration= params[:pupil][:pupil_address_of_registration]
      @living      = params[:pupil][:pupil_address_of_living]
      @home_phone  = params[:pupil][:pupil_phone_attributes][:pupil_home_number]
      @mobile_phone= params[:pupil][:pupil_phone_attributes][:pupil_mobile_number]
      @login       = params[:pupil][:user_attributes][:user_login]
      @password    = params[:pupil][:user_attributes][:password]
      
      case sex
        when 'm' then @pupil_sex_man, @pupil_sex_woman = true, false
        when 'w' then @pupil_sex_man, @pupil_sex_woman = false, true
      end
    end 
  end
  
  def create
    pupil = Pupil.new( params[:pupil] )
    pupil.user.user_role = "pupil"
    
    if pupil.save 
      flash[:success] = "Ученик успешно создан!"
      redirect_to pupils_path
    else
      flash[:error] = pupil.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                             :two_words_connector => ", "
      redirect_to new_pupil_path( params )                                                        
    end
  end
end
