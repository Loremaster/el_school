# encoding: UTF-8
class ParentsMeetingsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :edit, :update ]
  before_filter :authenticate_school_heads, :only => [ :index ]

  def index
    @meeting = Meeting.find( params[:id] )
  end

  def edit
    @parents = []
    @class_code = get_class_code( current_user )                                          # This method stores in application_controller.
    @meeting = Meeting.find( params[:id] )
    @parents = get_parents_for_class( @class_code )                                       # This method stores in application_controller.
  end

  def update
    @class_code = get_class_code( current_user )                                          # This method stores in application_controller.
    @meeting = Meeting.find( params[:id] )

    if @meeting.update_attributes( params[:meeting] )
      redirect_to reports_path
      flash[:success] = "Родители на собрании успешно обновлены!"
    else
      flash.now[:error] = @meeting.errors
                                  .full_messages
                                  .to_sentence :last_word_connector => ", ",
                                               :two_words_connector => ", "
      render "edit"
    end
  end
end
