class StatisticsController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index_teacher ]

  def index_teacher

  end
end
