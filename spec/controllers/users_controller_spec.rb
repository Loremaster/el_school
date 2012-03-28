# encoding: UTF-8
require 'spec_helper'

describe UsersController do
  render_views
  
  describe "GET 'edit'" do
    describe "for non-signed users" do
      before(:each) do
        @user = Factory(:user, :user_login => "bla-bla")
        @user.user_role = "teacher"
        @user.save
      end
      
      it "should deny access for pages which can visit only admin" do
        get :edit, :id => @user
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как администратор/i
      end 
    end
    
    # describe "for signed-in not admins" do
    #   before(:each) do
    #     @user = Factory(:user, :user_login => "iTeach")
    #     @user.user_role = "teacher"
    #     @user.save
    #     test_sign_in( @user )
    #   end
    #   
    #   it "should deny access for pages which can visit only admin" do
    #     get :edit, :id => @user
    #     response.should redirect_to( pages_wrong_page_path )
    #     flash[:notice].should =~ /войдите в систему как администратор/i
    #   end
    # end

    describe "for signed-in admins" do
      before(:each) do
        @adm = Factory(:user, :user_login => "iadmin")
        @adm.user_role = "admin"
        @adm.save!
        test_sign_in( @adm )
      end
      
      it "should be acesses admins pages" do
        get :edit, :id => @adm
        response.should be_success
      end
    end  
  end

  describe "PUT 'update'" do
    before(:each) do
      @adm = Factory(:user)
      @adm.user_role = "admin"
      @adm.save!
      test_sign_in( @adm )
    end
    
    describe "failure" do
      before(:each) do
        @attr = { :user_login => "", :password => "" }
      end
      
      it "should not change with wrong attributes" do
        put :update, :id => @adm, :user => @attr
        response.should_not be_success
      end
      
      it "should not cnahge user attributes" do
        put :update, :id => @adm, :user => @attr
        @adm.reload
        @adm.user_login.should_not  == @attr[:user_login]
      end
      
      it "should have a flash message" do
        put :update, :id => @adm, :user => @attr
        flash[:error].should =~ /должен/
      end
    end
    
    describe "success" do
      before(:each) do
        @attr = { :user_login => "userLogin", :password => "Password" }
      end
      
      it "should redirect to users list" do
        put :update, :id => @adm, :user => @attr
        response.should redirect_to( admins_users_of_system_path )
      end
      
      it "should change the user login" do
        put :update, :id => @adm, :user => @attr
        @adm.reload
        @adm.user_login.should  == @attr[:user_login]
      end
      
      it "should have a flash message" do
        put :update, :id => @adm, :user => @attr
        flash[:success].should =~ /обновлен/
      end
    end
  end  
end
