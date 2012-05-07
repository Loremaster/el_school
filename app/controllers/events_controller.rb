class EventsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :index ]
  
  def index
    
  end
end
