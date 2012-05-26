# encoding: UTF-8
require 'spec_helper'

describe AttendancesController do
  render_views

  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!

    @r = FactoryGirl.create( :reporting )

    # Curriculum and Timetable should link to same class.
    @r.lesson.timetable.school_class = @r.lesson.timetable.curriculum.school_class
    @r.lesson.timetable.school_class.save!

    # Make created user teacher.
    @r.lesson.timetable.curriculum.qualification.teacher.user.user_role = "teacher"
    @r.lesson.timetable.curriculum.qualification.teacher.user.save!
    @tch = @r.lesson.timetable.curriculum.qualification.teacher.user

    # Creating shortcuts.
    @subject_name = @r.lesson.timetable.curriculum.qualification.subject.subject_name
    @class_code = @r.lesson.timetable.curriculum.school_class.class_code
    @lesson = @r.lesson

    # Creating pupil and save for him existing class.
    @pupil = FactoryGirl.create( :pupil )
    @pupil.school_class = @r.lesson.timetable.curriculum.school_class
    @pupil.save!

    @attendance = Attendance.create( :pupil_id => @pupil.id, :lesson_id => @lesson.id,
                                     :visited => true )
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show attendance" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code,
                    :lesson_id => @lesson.id, :p_id => @pupil.id }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show attendance" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code,
                    :lesson_id => @lesson.id, :p_id => @pupil.id }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should show attendance" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code,
                    :lesson_id => @lesson.id, :p_id => @pupil.id }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    before(:each) do
      Estimation.create( :reporting_id => @r.id, :pupil_id => @pupil.id,                  # Estimation should already exist here.
                         :nominal => 4 )
    end

    describe "for non-signed users" do
      it "should deny access" do
        get :edit, { :id => @attendance, :subject_name => @subject_name,
                     :class_code => @class_code, :lesson_id => @lesson.id,
                     :p_id => @pupil.id }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :edit, { :id => @attendance, :subject_name => @subject_name,
                     :class_code => @class_code, :lesson_id => @lesson.id,
                     :p_id => @pupil.id }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should show attendance" do
        get :edit, { :id => @attendance, :subject_name => @subject_name,
                     :class_code => @class_code, :lesson_id => @lesson.id,
                     :p_id => @pupil.id }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
end
