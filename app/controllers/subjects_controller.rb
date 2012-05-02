# encoding: UTF-8
class SubjectsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create, :edit, 
                                                       :update ]
  
  def index  
    @all_subjects = Subject.order('subject_name')  
  end
  
  def new
    @everpresent_field_placeholder, @subj_text = "Обязательное поле", ""
    @subj_text = params[:subject][:subject_name] if params.has_key?( :subject )           # Read subject name form param if such data exists.    
    @subject = Subject.new
  end
  
  def create
    @subject = Subject.new( params[:subject] )
    
    if @subject.save
      redirect_to subjects_path
      flash[:success] = "Предмет успешно создан!"
    else                                               
      flash.now[:error] = @subject.errors.full_messages
                                         .to_sentence :last_word_connector => ", ",        
                                                      :two_words_connector => ", "
      render 'new'                                                                        # Rendering new template via Create method.
    end
  end
  
  def edit
    @everpresent_field_placeholder = "Обязательное поле"
    @subject = Subject.find( params[:id] )
  end
  
  def update
    @everpresent_field_placeholder = "Обязательное поле"
    @subject = Subject.find( params[:id] )
    
    if @subject.update_attributes( params[:subject] )
      redirect_to subjects_path
      flash[:success] = "Предмет успешно обновлен!"
    else
      flash.now[:error] = @subject.errors.full_messages
                                         .to_sentence :last_word_connector => ", ",        
                                                      :two_words_connector => ", "
      render 'edit'                                                                       # Rendering edit template via Update method.
    end
  end
end
