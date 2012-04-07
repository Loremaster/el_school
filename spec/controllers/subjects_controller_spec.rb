# encoding: UTF-8
require 'spec_helper'

describe SubjectsController do
  render_views
  
  before(:each) do
    @adm = Factory( :user, :user_login => "usr" )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = Factory( :user, :user_login => "shh" )
    @sh.user_role = "school_head"
    @sh.save!
    
    @subj = Factory( :subject )
    
    @attr = { :subject_name => "Psy"}
    @wrong_attr = { :subject_name => " " }
  end 
  
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to see subjects" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to see subjects" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show subjects" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
  
  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to see subjects" do
        get :new
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to see subjects" do
        get :new
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show subjects" do
        get :new
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
  
  describe "POST 'create'" do
    describe "for non-signed users" do
      it "should deny access to create subjects" do
        expect do
          post :create, :subject => @attr
          response.should redirect_to( signin_path )
          flash[:notice].should =~ /войдите в систему как завуч/i
        end.should_not change(Subject, :count)
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to create subjects" do
        expect do
          post :create, :subject => @attr
          response.should redirect_to( pages_wrong_page_path )
          flash[:error].should =~ /вы не можете увидеть эту страницу/i
        end.should_not change(Subject, :count)
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should create subjects" do
        expect do
          post :create, :subject => @attr
        end.should change(Subject, :count).by(1)
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access to edit subject" do
        get :edit, :id => @subj
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access" do
        get :edit, :id => @subj
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for sign-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should allow to edit subjects" do
        get :edit, :id => @subj
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    describe "for non-signed users" do
      it "should deny access to update subjects" do
        put :update, :id => @subj, :subject => @wrong_attr
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to update subjects" do
        put :update, :id => @subj, :subject => @wrong_attr
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should not update subject with wrong params" do
        put :update, :id => @subj, :subject => @wrong_attr
        @subj.reload
        @subj.subject_name.should_not  == @attr[:subject_name]
      end
      
      it "should update subject with correct params" do
        put :update, :id => @subj, :subject => @attr
        @subj.reload
        @subj.subject_name.should  == @attr[:subject_name]
      end
    end
  end
end
