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

    @parent = FactoryGirl.create( :parent )
    @parent.user.user_role = "parent"
    @parent.save!
    @parent_user = @parent.user

    @school_class = FactoryGirl.create( :school_class )
    @curriculum = FactoryGirl.create( :curriculum )
    @attr_timetable = { :school_class_id => @school_class.id,
                        :curriculum_id => @curriculum.id,
                        :tt_day_of_week => "Mon",
                        :tt_number_of_lesson => 1,
                        :tt_room => '123',
                        :tt_type => 'Primary lesson' }
    @timetable = Timetable.create( @attr_timetable )
  end

  describe "GET 'index_class_head'" do
    before(:each) do
      school_class = FactoryGirl.create( :school_class )
      @ch = school_class.teacher_leader.user
      @ch.user_role = "class_head"
      @ch.save
    end

    describe "for non-signed users" do
      it "should deny access to show timetables" do
        get :index_class_head
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как классный руководитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :index_class_head
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in class-headed" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should show" do
        get :index_class_head
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'index_for_pupil'" do
    before(:each) do
      pupil = FactoryGirl.create( :pupil )
      pupil.user.user_role = "pupil"
      pupil.user.save!
      @pupil = pupil.user
    end

    describe "for non-signed users" do
      it "should deny access to show timetables" do
        get :index_for_pupil
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как ученик/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :index_for_pupil
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in pupils" do
      before(:each) do
        test_sign_in( @pupil )
      end

      it "should show get timetables page" do
        get :index_for_pupil
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'index_for_parent'" do
    describe "for non-signed users" do
      it "should deny access to show timetables" do
        get :index_for_parent
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как родитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show timetables" do
        get :index_for_parent
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in parents" do
      before(:each) do
        test_sign_in( @parent_user )
      end

      it "should show timetables page" do
        get :index_for_parent
        response.should be_success
        flash[:error].should be_nil
      end

      it "should should timetable for school class" do
        get :index_for_parent, { :class_code => @school_class.class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
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

      it "should show timetables page" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end

      it "should should timetable for school class" do
        get :index, { :class_code => @school_class.class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show creating timetable's page" do
        get :new, { :class_code => @school_class.class_code }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show creating timetable's page" do
        get :new, { :class_code => @school_class.class_code }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end

      it "should not show timetable if it's already exists" do
        get :new, { :class_code => @school_class.class_code }
        response.should_not be_success
        flash[:notice].should_not be_nil
      end

      it "should show timetable if it's has not been created" do
        school_class2 = FactoryGirl.create( :school_class, :class_code => '231' )
        get :new, { :class_code => school_class2.class_code }
        flash[:notice].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, :id => @timetable
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end

    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :edit, :id => @timetable
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for sign-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end

      it "should allow to edit timetables" do
        get :edit, :id => @timetable
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    describe "for non-signed users" do
      it "should deny access" do
        put :update, :id => @timetable,
                     :timetable => @timetable.attributes.merge( :tt_room => "333" )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        put :update, :id => @timetable,
                     :timetable => @timetable.attributes.merge( :tt_room => "333" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end

      it "should reject to update timetable with wrong params" do
        text = "  "
        put :update, :id => @timetable,
                     :order => @timetable.attributes.merge(:tt_number_of_lesson => text )
        @timetable.reload
        @timetable.tt_number_of_lesson.should_not == text
      end

      it "should update timetable with correct params" do
        text = "333"
        put :update, :id => @timetable,
                     :timetable => @timetable.attributes.merge( :tt_room => text )
        @timetable.reload
        @timetable.tt_room.should == text
      end
    end
  end
end
