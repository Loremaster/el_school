# encoding: UTF-8
class MeetingsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create, :edit, 
                                                       :update ]
  
  def index
    @meetings = Meeting.all
    @meeting_exist = Meeting.first ? true : false
    @classes = SchoolClass.order( :class_code ) 
    
    if params.has_key?( :class_code )
      @meetings = SchoolClass.where( "class_code = ?", params[:class_code] ).first.meetings      
    end
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
  
  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @meeting = Meeting.find( params[:id] )
  end
  
  def update
    @everpresent_field_placeholder = "Обязательное поле"
    @meeting = Meeting.find( params[:id] )
    
    if @meeting.update_attributes( params[:meeting] )
      redirect_to meetings_path
      flash[:success] = "Собрание успешно обновлено!"
    else
      flash[:error] = @meeting.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                                :two_words_connector => ", "
      render 'edit'
    end
  end
end
