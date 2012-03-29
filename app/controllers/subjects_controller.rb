# encoding: UTF-8
class SubjectsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]
  
  def index  
    @all_subjects = Subject.all  
  end
  
  #TODO: keep value in form
  #TODO: test.  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new( params[:subject] )
    
    if @subject.save
      redirect_to subjects_path
      flash[:success] = "Предмет успешно создан!"
    else
      redirect_to new_subject_path                                                
      flash[:error] = @subject.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                                :two_words_connector => ", "
    end
  end
end
