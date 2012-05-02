# encoding: UTF-8
require 'spec_helper'

describe TimetablesController do
  render_views
  
  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = FactoryGirl.create( :user )
    @sh.user_role = "school_head"
    @sh.save!
  end
  
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show timetables" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show timetables" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show timetables" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end  
end
