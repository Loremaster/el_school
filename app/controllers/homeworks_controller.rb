# encoding: UTF-8
class HomeworksController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index ]
end
