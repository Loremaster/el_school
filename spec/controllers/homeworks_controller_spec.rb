# encoding: UTF-8
require 'spec_helper'

describe HomeworksController do
  render_views

  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!

    @hw = FactoryGirl.create( :homework )

    # Curriculum and Timetable should link to same class.
    @hw.lesson.timetable.school_class = @hw.lesson.timetable.curriculum.school_class
    @hw.lesson.timetable.school_class.save!

    # Make created user teacher.
    @hw.lesson.timetable.curriculum.qualification.teacher.user.user_role = "teacher"
    @hw.lesson.timetable.curriculum.qualification.teacher.user.save!

    # Creating shortcuts.
    @teacher = @hw.lesson.timetable.curriculum.qualification.teacher.user
    @subject_name = @hw.lesson.timetable.curriculum.qualification.subject.subject_name
    @class_code = @hw.lesson.timetable.curriculum.school_class.class_code
  end

  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :index, { :subject_name => @subject_name, :class_code => @class_code }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :index, { :subject_name => @subject_name, :class_code => @class_code }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @teacher )
      end

      it "should show" do
        get :index, { :subject_name => @subject_name, :class_code => @class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @teacher )
      end

      it "should show" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, { :id => @hw, :subject_name => @subject_name, :class_code => @class_code }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :edit, { :id => @hw, :subject_name => @subject_name, :class_code => @class_code }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @teacher )
      end

      it "should show" do
        get :edit, { :id => @hw, :subject_name => @subject_name, :class_code => @class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
end
