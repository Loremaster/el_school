class PupilsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]
  
  def index  
    @pupil_exist = Pupil.first ? true : false 
    @pupils = Pupil.all 
  end
  
  def new 
    @pupil = Pupil.new   
  end
  
  def create
  end
end
