# encoding: UTF-8
require 'spec_helper'

describe PupilsController do
  render_views
  
  describe "GET 'index'" do
    describe "for non-signed pupils" do
      it "should deny access to see pupils" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        @adm = Factory( :user )
        @adm.user_role = "admin"
        @adm.save!
        test_sign_in( @adm )
      end
      
      it "should deny access to see pupils" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        @sh = Factory( :user )
        @sh.user_role = "school_head"
        @sh.save!
        test_sign_in( @sh )
      end
      
      it "should show pupils" do
        get :index
        response.should be_success
      end
    end
  end
end
