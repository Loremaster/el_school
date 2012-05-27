class ResultsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]
  
  def index
    
  end
end
