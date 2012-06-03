# encoding: UTF-8
require 'spec_helper'

describe ParentsInfosController do
  render_views

  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!

    @parent = FactoryGirl.create( :parent )
    @parent.user.user_role = "parent"
    @parent.save!
    @parent_user = @parent.user
  end

  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show parents info" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как родитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show parents info" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in parents" do
      before(:each) do
        test_sign_in( @parent_user )
      end

      it "should show parents info" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, :id => @parent
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как родитель/i
      end
    end

    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :edit, :id => @parent
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for sign-in parents" do
      before(:each) do
        test_sign_in( @parent_user )
      end

      it "should allow to edit parent's info" do
        get :edit, :id => @parent
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    describe "for non-signed users" do
      it "should deny access" do
        put :update, :id => @parent,
                     :order => @parent.attributes.merge( :parent_last_name => "some" )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как родитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        put :update, :id => @parent,
                     :order => @parent.attributes.merge( :parent_last_name => "some" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in parents" do
      before(:each) do
        test_sign_in( @parent_user )
      end

      it "should reject to update order with wrong params" do
        text = "  "
        put :update, :id => @parent,
                     :parent => @parent.attributes.merge( :parent_last_name => text )
        @parent.reload
        @parent.parent_last_name.should_not == text
      end

      it "should update parent with correct params" do
        text = "last"
        put :update, :id => @parent,
                     :parent => @parent.attributes.merge( :parent_last_name => text )
        @parent.reload
        @parent.parent_last_name.should == text
      end
    end
  end
end
