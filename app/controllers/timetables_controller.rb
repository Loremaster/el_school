# encoding: UTF-8
class TimetablesController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]

  def index
    
  end
  
  def new
    
  end
  
  def create
    
  end
end
