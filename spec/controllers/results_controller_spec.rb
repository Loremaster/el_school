# encoding: UTF-8
require 'spec_helper'

describe ResultsController do
  render_views

  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!

    @result = FactoryGirl.create( :result )

    # Make created user teacher.
    @result.curriculum.qualification.teacher.user.user_role = "teacher"
    @result.curriculum.qualification.teacher.user.save!
    @tch = @result.curriculum.qualification.teacher.user

    # Creating shortcuts.
    @subject_name = @result.curriculum.qualification.subject.subject_name
    @class_code = @result.curriculum.school_class.class_code
    @pupil = FactoryGirl.create( :pupil,
                                 :school_class_id => @result.curriculum.school_class.id )
  end

  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show results" do
        get :index, { :subject_name => @subject_name, :class_code => @class_code }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show results" do
        get :index, { :subject_name => @subject_name, :class_code => @class_code }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should show results page" do
        get :index, { :subject_name => @subject_name, :class_code => @class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show results" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code,
                    :p_id => @pupil.id }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show results" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code,
                    :p_id => @pupil.id }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should show results page" do
        get :new, { :subject_name => @subject_name, :class_code => @class_code,
                    :p_id => @pupil.id }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access to show results edit page" do
        get :edit, { :id => @result, :subject_name => @subject_name,
                     :class_code => @class_code }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to show results edit page" do
        get :edit, { :id => @result, :subject_name => @subject_name,
                     :class_code => @class_code }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should show results edit page" do
        get :edit, { :id => @result, :subject_name => @subject_name,
                     :class_code => @class_code }
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    describe "for non-signed users" do
      it "should deny access to update results" do
        put :update, :id => @result,
                     :result => @result.attributes.merge( :quarter_1 => 5 )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как учитель/i
      end
    end

    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end

      it "should deny access to update results" do
        put :update, :id => @result,
                     :result => @result.attributes.merge( :quarter_1 => 5 )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end

    describe "for signed-in teachers" do
      before(:each) do
        test_sign_in( @tch )
      end

      it "should update results with valid params" do
        value = 5
        put :update, :id => @result,
                     :result => @result.attributes.merge( :quarter_1 => value )
        @result.reload
        @result.quarter_1.should == value
      end

      it "should not update results with invalid params" do
        value = 0
        put :update, :id => @result,
                     :result => @result.attributes.merge( :quarter_1 => value )
        @result.reload
        @result.quarter_1.should_not == value
      end
    end
  end
end
