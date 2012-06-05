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

    # We create user this way because it auto creates school class (controller need that.)
    @pupil = FactoryGirl.create( :pupil )
    @pupil.user.user_role = "pupil"
    @pupil.user.save!

    # Creating parent and link to his child - pupil.
    pp = FactoryGirl.create( :parent_pupil, :pupil_id => @pupil.id )
    pp.parent.user.user_role = "parent"
    pp.parent.user.save!

    @parent = pp.parent.user
    @meeting = FactoryGirl.create( :meeting )
  end

  describe "GET 'index_for_pupil'" do
    before(:each) do
      pupil = FactoryGirl.create( :pupil )
      pupil.user.user_role = "pupil"
      pupil.user.save!
      @pupil = pupil.user
    end

    describe "for non-signed users" do
      it "should deny access to show meetings" do
        get :index_for_pupil
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как ученик/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show meetings" do
        get :index_for_pupil
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in pupils" do
      before(:each) do
        test_sign_in( @pupil )
      end

      it "should show meetings" do
        get :index_for_pupil
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'index_for_parent'" do
    describe "for signed-in parents" do
      before(:each) do
        test_sign_in( @parent )
      end

      it "should show" do
        get :index_for_parent, { :p_id => @pupil.id }
        response.should be_success
        flash[:error].should be_nil
      end
    end
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

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, :id => @meeting
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
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

    describe "for sign-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end

      it "should allow to edit meetings" do
        get :edit, :id => @meeting
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    describe "for non-signed users" do
      it "should deny access" do
        put :update, :id => @meeting,
                      :meeting => @meeting.attributes.merge( :meeting_theme => "some" )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        put :update, :id => @meeting,
                     :meeting => @meeting.attributes.merge( :meeting_theme => "some" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end

      it "should update meeting with correct attributes" do
         text = "last"
         put :update, :id => @meeting,
                      :meeting => @meeting.attributes.merge( :meeting_theme => text )
         @meeting.reload
         @meeting.meeting_theme.should == text
      end

      it "should  reject update meeting with invalid attributes" do
         text = "  "
         put :update, :id => @meeting,
                      :meeting => @meeting.attributes.merge( :meeting_theme => text )
         @meeting.reload
         @meeting.meeting_theme.should_not == text
      end
    end
  end
end
