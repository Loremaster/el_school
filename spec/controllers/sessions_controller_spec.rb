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
        flash.now[:error].should =~ /invalid/i
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
end
