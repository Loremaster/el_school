# encoding: UTF-8
require 'spec_helper'

describe UsersController do
  render_views
  
  before(:each) do
    @adm = Factory(:user, :user_login => "iadmin")
    @adm.user_role = "admin"
    @adm.save!
    
    @user = Factory(:user, :user_login => "bla-bla")
    @user.user_role = "teacher"
    @user.save
  end
    
    
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to see users of system" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как администратор/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
            
      it "should accept access to get users list" do
        get :index
        response.should be_success
      end
      
      it "should have legend for users list page" do
        get :index
        response.should have_selector("legend", :content => "Список учетных записей системы")
      end
      
      it "should have admin user in users list" do
        pass_text = '*' * 10
        get :index
        response.body.should have_selector( "tr") do
          have_selector('td', :content => @adm.user_role)
          have_selector('td', :content => @adm.user_login)
          have_selector('td', :content => pass_text)
        end
      end
    end  
  end
  
  describe "GET 'edit'" do
    describe "for non-signed users" do      
      it "should deny access to edit users" do
        get :edit, :id => @user
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как администратор/i
      end 
    end
   
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should accept access to edit users" do
        get :edit, :id => @adm
        response.should be_success
      end
    end     
  end

  describe "PUT 'update'" do
    before(:each) do
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
        response.should redirect_to( users_path )
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
