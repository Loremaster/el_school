# encoding: UTF-8
require 'spec_helper'

describe MeetingsController do
  render_views
  
  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = FactoryGirl.create( :user )
    @sh.user_role = "school_head"
    @sh.save!
    
    @meeting = FactoryGirl.create( :meeting )
  end
  
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show meetings" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show meetings" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show meetings" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
  
  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show creating meeting's page" do
        get :new
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show creating meeting's page" do
        get :new
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
  
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show meetings" do
        get :new
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
  
  describe "POST 'create'" do
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should create meeting" do
        expect do
          post :create, :meeting => @meeting.attributes.merge( :meeting_theme => "some" )
        end.should change( Meeting, :count ).by( 1 )
      end
      
      it "should not create meeting with invalid attributes" do
        expect do    
          post :create, :meeting => @meeting.attributes.merge( :meeting_theme => "  " )
        end.should_not change( Meeting, :count )
      end
    end
  end
end