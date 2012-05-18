# encoding: UTF-8
require 'spec_helper'

describe LessonsController do
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

    curriculum = FactoryGirl.create( :curriculum )                                        # Automatically creating school class ans set qualification for class.
    curriculum.qualification.teacher = teacher                                            # Our teacher teach subject.
    curriculum.qualification.save!                                                        # Save modifications in qualification.

    @subject_name = curriculum.qualification.subject.subject_name
    @class_code = curriculum.school_class.class_code

    attr_timetable =  { :school_class_id => curriculum.school_class.id,
                        :curriculum_id => curriculum.id,
                        :tt_day_of_week => "Mon",
                        :tt_number_of_lesson => 1,
                        :tt_room => '123',
                        :tt_type => 'Primary lesson' }
    timetable = Timetable.create( attr_timetable )

    attr_lesson =  { :timetable_id => timetable.id,
                     :lesson_date => "#{Date.today}" }
    @lesson = Lesson.create( attr_lesson )
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show lesson" do
        get :new
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show lesson" do
        get :new
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should show lesson" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, :id => @lesson
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        get :edit, :id => @lesson
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should show lesson's edit page" do
        get :edit,
            { :id => @lesson, :subject_name => @subject_name, :class_code => @class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update'" do
    describe "for non-signed users" do
      it "should deny access" do
        put :update, :id => @lesson,
                     :lesson => @lesson.attributes.merge( :lesson_date => "#{Date.today}" )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access" do
        put :update, :id => @lesson,
                     :lesson => @lesson.attributes.merge( :lesson_date => "#{Date.today}" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should update lesson with correct params" do
        input = "#{Date.today.strftime("%Y-%m-%d")}"                                      # Save value with chosen type of representing.
        put :update,
            { :id => @lesson, :subject_name => @subject_name, :class_code => @class_code },
            :lesson => @lesson.attributes.merge( :lesson_date => input )
        @lesson.reload

        out = @lesson.lesson_date.strftime("%Y-%m-%d")                                    # Get correct view before compare.
        out.should == input
      end

      it "should reject to update lesson with invalid params" do
        input = ""
        put :update,
            { :id => @lesson, :subject_name => @subject_name, :class_code => @class_code },
            :lesson => @lesson.attributes.merge( :lesson_date => input )
        @lesson.reload

        out = @lesson.lesson_date.strftime("%Y-%m-%d")                                    # Get correct view before compare.
        out.should_not == input
      end
    end
  end
end
