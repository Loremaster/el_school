class JournalsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]

  def index

  end
end
