class AdminsController < ApplicationController
  before_filter :authenticate, :only => [ :backups, :users_of_system ]

  def backups

  end

  def users_of_system
    @all_users = User.all
  end
end
