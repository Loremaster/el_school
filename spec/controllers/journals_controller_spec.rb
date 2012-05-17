# encoding: UTF-8
require 'spec_helper'

describe JournalsController do
  render_views

  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!

    # Creating user with role "teacher" and then create teacher and link it to the user.
    @tch = FactoryGirl.create( :user )
    @tch.user_role = "teacher"
    @tch.save!
    teacher = FactoryGirl.create( :teacher )
    teacher.user = @tch
    teacher.save!
  end

  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show journal" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show journal" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should show journal" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
end
