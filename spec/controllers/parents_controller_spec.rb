# encoding: UTF-8
require 'spec_helper'

describe ParentsController do
  render_views
  
  before(:each) do
    @adm = FactoryGirl.create( :user, :user_login => "usr" )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = FactoryGirl.create( :user, :user_login => "shh" )
    @sh.user_role = "school_head"
    @sh.save!
  end
  
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show parents" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show parents" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show parents" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show create page" do
        get :new
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show create page" do
        get :new
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
  
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show parents" do
        get :new
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
  
end
