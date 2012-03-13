class PagesController < ApplicationController
  before_filter  :authenticate, :only => :wrong_page                           #TODO write test for that

  #This page appears if signed in user can't access some page
  def wrong_page
  end
end
