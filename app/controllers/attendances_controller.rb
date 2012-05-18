# encoding: UTF-8
class AttendancesController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :new, :create ]

  def new

  end

  def create

  end
end
