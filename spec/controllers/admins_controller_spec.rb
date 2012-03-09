# encoding: UTF-8
require 'spec_helper'

describe AdminsController do
  render_views
  
  describe "GET 'users_of_system'" do
    describe "for non-signed-in users" do
      it "should deny access" do
        get :users_of_system
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как администратор/i
      end
    end
  end
  
  describe "for signed-in admins" do
    before(:each) do
      @user = Factory(:user)
      test_sign_in( @user )
    end
      
    it "should accept access to users list" do
      get :users_of_system
      response.should be_success
    end
    
    it "should have legend for users list page" do
      get :users_of_system
      response.should have_selector("legend", :content => "Список учетных записей системы")
    end
    
    it "should have legend for backups page" do
      get :backups
      response.should have_selector("legend", :content => "Бекапы")
    end
    
    it "should have admin user in users list" do
      pass_text = '*' * 10
      get :users_of_system
      response.body.should have_selector( "tr") do
        have_selector('td', :content => @user.user_role)
        have_selector('td', :content => @user.user_login)
        have_selector('td', :content => pass_text)
      end
    end  
  end
end

