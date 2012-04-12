# encoding: UTF-8
class PupilsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]
  
  def index  
    @pupil_exist = Pupil.first ? true : false 
    @pupils = Pupil.all 
  end
  
  def new 
    @pupil = Pupil.new
    @user = User.new   
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
      redirect_to new_pupil_path                                                        
    end
  end
end
