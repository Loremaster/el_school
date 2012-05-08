# encoding: UTF-8
class ParentsMeetingsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :edit, :update ]
  
  #TODO: test edit/update methods.
  def edit
    @class_code = get_class_code( current_user )
    @meeting = Meeting.find( params[:id] )
    @parents = Parent.all
  end
  
  def update
    @class_code = get_class_code( current_user )
    @meeting = Meeting.find( params[:id] )
    
    if @meeting.update_attributes(params[:meeting])
      redirect_to reports_path
      flash[:success] = "Родители на собрании успешно обновлены!"
    else
      flash.now[:error] = @meeting.errors.full_messages
                                         .to_sentence :last_word_connector => ", ",        
                                                      :two_words_connector => ", "
      render "edit"
    end
  end
end
