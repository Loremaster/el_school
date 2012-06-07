# encoding: UTF-8
require 'spec_helper'

describe ParentsMeetingsController do
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
    @school_class = FactoryGirl.create( :school_class )
    @ch = @school_class.teacher_leader.user
    @ch.user_role = "class_head"
    @ch.save

    @meeting = FactoryGirl.create( :meeting )
    @meeting.school_class = @school_class
    @meeting.save
  end

  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :index, { :id => @meeting.id }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end

    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :index, { :id => @meeting.id }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for sign-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end

      it "should show" do
        get :index, { :id => @meeting.id }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, :id => @meeting
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как Классный руководитель/i
      end
    end

    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :edit, :id => @meeting
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for sign-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should allow to edit meeting" do
        get :edit, :id => @meeting
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    before(:each) do
      # Create pupil and save school_class for him.
      @pupil = FactoryGirl.create( :pupil )
      @pupil.school_class = @school_class
      @pupil.save

      # Create parent and save created pupil for him.
      @parent = FactoryGirl.create( :parent )
      @parent.pupil_ids = @pupil.id
      @parent.save
    end

    describe "for signed-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should update event with correct params" do
        par_id = @parent.id
        put :update, :id => @meeting,
                     :event => @meeting.attributes.merge( :parent_ids => par_id )         # In parent_ids we pass parent id, e.g. we tell that parent visited meeting.
        @meeting.reload
        @meeting.parents.first. == @parent
      end
    end
  end
end
