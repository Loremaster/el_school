class EventsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :index, :new, :create ]
  
  def index
    @class_code = current_user.teacher_leader.school_class.class_code
  end
  
  def new
    @class_code = current_user.teacher_leader.school_class.class_code
  end
  
  def create
    
  end
end
