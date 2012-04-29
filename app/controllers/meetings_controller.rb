# encoding: UTF-8
class MeetingsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]
  
  def index
    @meetings = Meeting.all
    @meeting_exist = Meeting.first ? true : false 
  end
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @meeting = Meeting.new
  end
  
  def create
    @everpresent_field_placeholder = "Обязательное поле"
    @meeting = Meeting.new( params[:meeting] )
    
    if @meeting.save
      redirect_to meetings_path
      flash[:success] = "Собрание успешно создано!"
    else
      flash[:error] = @meeting.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                                :two_words_connector => ", "
      render 'new'
    end
  end
end
