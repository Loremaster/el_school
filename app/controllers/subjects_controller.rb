class SubjectsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index ]
  
  def index    
  end
end
