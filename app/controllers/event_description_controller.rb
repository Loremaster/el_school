# encoding: UTF-8
class EventDescriptionController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :edit, :update ]
  before_filter :authenticate_school_heads, :only => [ :index ]

  def index
    @event = Event.find( params[:id] )
  end

  def edit
    event = Event.find( params[:id] ); @event = nil;
    @school_class = get_class( current_user )

    if not @school_class.nil? and not event.nil? and                                      # If school_class exists and input event exists
       current_user.teacher_leader.school_class.events.include? event                     # And event is event of class of teaher leader.

      @event = event
    end
  end

  def update
    event = Event.find( params[:id] ); @event = nil;
    @school_class = get_class( current_user )

    if not @school_class.nil? and not event.nil? and                                      # If school_class exists and input event exists
       current_user.teacher_leader.school_class.events.include? event                     # And event is event of class of teaher leader.

      @event = event

      if @event.update_attributes( params[:event] )
        flash[:success] = "Отчет о мероприятии успешно обновлен!"
        redirect_to reports_path
      else
        flash.now[:error] = @event.errors
                                  .full_messages
                                  .to_sentence :last_word_connector => ", ",
                                               :two_words_connector => ", "
        render "edit"
      end
    end
  end
end
