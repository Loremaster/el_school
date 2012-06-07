# encoding: UTF-8
require 'spec_helper'

describe EventDescriptionController do
  render_views

  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!

    @sh = FactoryGirl.create( :user )
    @sh.user_role = "school_head"
    @sh.save!

    # In event controller we get school class code for teacher_leader.
    # So here we do a trick. We create teacher leader via school class and make it's
    # user's role class_head.
    school_class = FactoryGirl.create( :school_class )
    @ch = school_class.teacher_leader.user
    @ch.user_role = "class_head"
    @ch.save

    @event = FactoryGirl.create( :event, :school_class_id => school_class.id )
  end

  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :index, { :id => @event.id }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end

    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :index, { :id => @event.id }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for sign-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end

      it "should show" do
        get :index, { :id => @event.id }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, :id => @event
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как Классный руководитель/i
      end
    end

    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :edit, :id => @event
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for sign-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should allow to edit event's description" do
        get :edit, :id => @event
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update'" do
    describe "for non-signed users" do
      it "should deny access" do
        put :update, :id => @event,
                     :order => @event.attributes.merge(:description => "fff" )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как Классный руководитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        put :update, :id => @event,
                     :order => @event.attributes.merge(:description => "fff" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should update event's description with param" do
        text = "text"
        put :update, :id => @event,
                     :event => @event.attributes.merge( :description => text )
        @event.reload
        @event.description.should == text
      end
    end
  end
end
