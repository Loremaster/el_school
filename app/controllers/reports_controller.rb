# encoding: UTF-8
class ReportsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :index ]

  def index
    @school_class = get_class( current_user ); @meeting_exist = false

    unless @school_class.nil?
      @class_code = @school_class.class_code
      @meetings = Meeting.select{ |m| m.school_class.class_code == @class_code }            # Get parents meetings for class of current class head.
      @meeting_exist = @meetings.first ? true : false
    end
  end
end
