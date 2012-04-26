class ParentsController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index ]

  def index
    @parent_exist = Parent.first ? true : false 
    @parents = Parent.all
  end
end
