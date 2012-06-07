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

  describe "GET 'index_class_head'" do
    before(:each) do
      school_class = FactoryGirl.create( :school_class )
      @ch = school_class.teacher_leader.user
      @ch.user_role = "class_head"
      @ch.save

      @qualification = FactoryGirl.create( :qualification,
                                           :teacher_id => school_class.teacher_leader.teacher.id )
    end

    describe "for non-signed users" do
      it "should deny access" do
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

    describe "for signed-in class-heads" do
      before(:each) do
        test_sign_in( @ch )
      end

      it "should show page without subject" do
        get :index_class_head
        response.should be_success
        flash[:error].should be_nil
      end

      it "should show page with subject" do
        get :index_class_head, { :s_id => @qualification.subject.id }
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
      it "should deny access to show pupil's journal" do
        get :index_for_pupil
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как ученик/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show pupil's journal" do
        get :index_for_pupil
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in pupils" do
      before(:each) do
        test_sign_in( @pupil )
      end

      it "should show journal without params" do
        get :index_for_pupil
        response.should be_success
        flash[:error].should be_nil
      end
    end
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

    describe "for non-signed users" do
      it "should deny access to show pupil's journal" do
        get :index_for_parent
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как родитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show pupil's journal" do
        get :index_for_parent
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in parents" do
      before(:each) do
        test_sign_in( @parent )
      end

      it "should show journal without params" do
        get :index_for_parent
        response.should be_success
        flash[:error].should be_nil
      end

      it "should show journal with pupil id" do
        get :index_for_parent, { :p_id => @pupil.id }
        response.should be_success
        flash[:error].should be_nil
      end
    end
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
