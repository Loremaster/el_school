# encoding: UTF-8
class ReportsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :index ]

  def index
    @school_class = get_class( current_user ); @meeting_exist = false; @event_exist = false

    unless @school_class.nil?
      @class_code = @school_class.class_code

      @meetings = Meeting.select{ |m| m.school_class.class_code == @class_code }            # Get parents meetings for class of current class head.
      @meeting_exist = @meetings.first ? true : false

      @events = events_for( @class_code )
      @event_exist = @events.first ? true : false
    end
  end

  private

    # Get events for school class via class code.
    def events_for( class_code )
      Event.select{|e| e.school_class.class_code == class_code }
           .sort_by{ |e| e[:event_begin_date] }
           .sort_by{ |e| e[:event_begin_time] }
    end
end
