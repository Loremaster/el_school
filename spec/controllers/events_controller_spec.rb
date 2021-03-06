# encoding: UTF-8
require 'spec_helper'

describe EventsController do
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

    @event = FactoryGirl.create( :event )
  end

  describe "GET 'index_for_parent'" do
    before(:each) do
      # We create user this way because it auto creates school class (controller need that.)
      @pupil = FactoryGirl.create( :pupil )
      @pupil.user.user_role = "pupil"
      @pupil.user.save!

      # Creating parent and link to his child - pupil.
      pp = FactoryGirl.create( :parent_pupil, :pupil_id => @pupil.id )
      pp.parent.user.user_role = "parent"
      pp.parent.user.save!

      @parent = pp.parent.user
    end

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

  describe "GET 'index_school_head'" do
    describe "for non-signed users" do
      it "should deny access to show events for school head" do
        get :index_school_head
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show events for school head" do
        get :index_school_head
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end

      it "should show events for school head" do
        get :index_school_head
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit_event_by_pupil'" do
    before(:each) do
      pupil = FactoryGirl.create( :pupil )
      pupil.user.user_role = "pupil"
      pupil.user.save!
      @pupil = pupil.user
    end

    describe "for non-signed users" do
      it "should deny access to show events for school head" do
        get :edit_event_by_pupil
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как ученик/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show events for school head" do
        get :edit_event_by_pupil
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in pupils" do
      before(:each) do
        test_sign_in( @pupil )
      end

      it "should show event" do
        get :edit_event_by_pupil
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'event_info_for_pupil'" do
    before(:each) do
      pupil = FactoryGirl.create( :pupil )
      pupil.user.user_role = "pupil"
      pupil.user.save!
      @pupil = pupil.user

      @event = FactoryGirl.create(:event, :school_class_id => @pupil.pupil.school_class.id)
    end

    describe "for non-signed users" do
      it "should deny access to show events" do
        get :edit_event_by_pupil, { :id => @event }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как ученик/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show events for school head" do
        get :edit_event_by_pupil, { :id => @event }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in pupils" do
      before(:each) do
        test_sign_in( @pupil )
      end

      it "should show event" do
        get :edit_event_by_pupil, { :id => @event }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show events" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как Классный руководитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show events" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should show events" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show creating event's page" do
        get :new
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как Классный руководитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show creating event's page" do
        get :new
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should show events" do
        get :new
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "POST 'create'" do
    describe "for non-signed users" do
      it "should deny access" do
        post :create, :event => @event.attributes.merge( :event_cost => "333" )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как Классный руководитель/i
      end

      it "should not create event" do
        expect do
          post :create, :event => @event.attributes.merge(:event_cost => " " )
        end.should_not change( Event, :count )
      end
    end

    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        post :create, :event => @event.attributes.merge( :event_cost => "333" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end

      it "should not create event" do
        expect do
          post :create, :event => @event.attributes.merge(:event_cost => " " )
        end.should_not change( Event, :count )
      end
    end

    describe "for signed-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should create event" do
        expect do
          post :create, :event => @event.attributes.merge( :event_cost => "333" )
        end.should change( Event, :count ).by( 1 )
      end

      it "should not create event with wrong params" do
        expect do
          post :create, :event => @event.attributes.merge( :event_cost => " " )
        end.should_not change( Event, :count )
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

      it "should allow to edit events" do
        get :edit, :id => @event
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    describe "for non-signed users" do
      it "should deny access" do
        put :update, :id => @event,
                     :order => @event.attributes.merge(:event_place => "fff" )
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
                     :order => @event.attributes.merge(:event_place => "fff" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should update event with correct params" do
        cost = 111
        put :update, :id => @event,
                     :event => @event.attributes.merge( :event_cost => cost )
        @event.reload
        @event.event_cost.should == cost
      end

      it "should reject to update event with wrong params" do
        text = "  "
        put :update, :id => @event,
                     :order => @event.attributes.merge(:event_place => text )
        @event.reload
        @event.event_place.should_not == text
      end
    end
  end
end
