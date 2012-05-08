# encoding: UTF-8
class ReportsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :index ]
  
  def index
    @class_code = get_class_code( current_user )
    @meetings = Meeting.select{ |m| m.school_class.class_code == @class_code }            # Get parents meetings for class of current class head.
    @meeting_exist = @meetings.first ? true : false
  end
end
