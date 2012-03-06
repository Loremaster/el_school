# encoding: UTF-8

require 'spec_helper'

describe SessionsController do
  render_views
  
  
  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end        
  end

  describe "POST 'create'" do
    describe "invalid signin" do
      before(:each) do
        @attr = { 
                  :user_login => "login",
                  :password => "invalid"
                 }
      end
      
      it "should have a flash.now message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /Не удается войти/i
      end

      it "should re-render the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end
    end
    
    describe "with valid email and password" do
      before(:each) do
         @attr_user = { 
                        :user_login => "Admin",
                        :user_role => "admin",
                        :password => "password"
                      }
         @user = User.create!( @attr_user )
      end
      
      it "should sign the user in" do
        post :create, :session => @attr_user
        controller.current_user.should == @user
        controller.should be_signed_in
      end
    end    
  end
  
  describe "DELETE 'destroy'" do
    it "should sign a user out" do
      @attr_user = { 
                      :user_login => "Admin",
                      :user_role => "admin",
                      :password => "password"
                    }
      @user = User.create!( @attr_user )
      test_sign_in( @user )
      delete :destroy
      controller.should_not be_signed_in
      response.should redirect_to(root_path)
    end
  end  
end
