# encoding: UTF-8
require 'spec_helper'

describe TeachersController do
  render_views
  
  before(:each) do
    @adm = FactoryGirl.create( :user, :user_login => "usr" )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = FactoryGirl.create( :user, :user_login => "shh" )
    @sh.user_role = "school_head"
    @sh.save!
    
    @tch = FactoryGirl.create( :teacher )
    @tch.user.user_role = "teacher"
    @tch.save!
  end
  
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to see teachers" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to see subjects" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show subjects" do
        get :index
        response.should be_success
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, :id => @tch
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access" do
        get :edit, :id => @tch
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show subjects" do
        get :edit, :id => @tch
        response.should be_success
      end
    end
  end
  
  # I have NO idea how to test PUT 'update'
end
