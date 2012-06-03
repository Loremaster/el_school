# encoding: UTF-8
class ParentsInfosController < ApplicationController
  before_filter :authenticate_parents, :only => [ :index, :edit, :update ]

  def index
    @parent = current_user.parent
  end

  def edit

  end

  def update

  end
end
