# encoding: UTF-8
require 'spec_helper'

describe SchoolClassesController do
  render_views
  
  before(:each) do
    @adm = FactoryGirl.create( :user, :user_login => "usr" )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = FactoryGirl.create( :user, :user_login => "shh" )
    @sh.user_role = "school_head"
    @sh.save!
    
    @user = FactoryGirl.create( :user )
    @teacher = FactoryGirl.create( :teacher )
    @teacher_leader = @user.create_teacher_leader({ 
                                                    :user_id => @user.id, 
                                                    :teacher_id => @teacher.id 
                                                  })
    @school_class = FactoryGirl.create( :school_class )                                              
  end
  
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show classes" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show classes" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show classes" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end  

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show class's creation page" do
        get :new
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show class's creation page" do
        get :new
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show class's creation page" do
        get :new
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end
  
  describe "POST 'create'" do
    before(:each) do
      @attr = { 
               :class_code => '11d', 
               :date_of_class_creation => Date.today,
               :teacher_leader_id => @teacher_leader.id
              }
    end 
    
    describe "for non-signed users" do
      it "should deny to post class's data" do
        expect do
          post :create, :school_class => @attr
          response.should redirect_to( signin_path )
          flash[:notice].should =~ /войдите в систему как завуч/i
        end.should_not change(SchoolClass, :count)
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny to post class's data" do
        expect do
          post :create, :school_class => @attr
          response.should redirect_to( pages_wrong_page_path )
          flash[:error].should =~ /вы не можете увидеть эту страницу/i
        end.should_not change(SchoolClass, :count)
      end
    end
     
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should create class's data" do
        expect do
          post :create, :school_class => @attr
        end.should change(SchoolClass, :count).by( 1 )
      end
    end  
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access to edit schol class" do
        get :edit, :id => @school_class
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to edit school class" do
        get :edit, :id => @school_class
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should get page to edit pupil" do
        get :edit, :id => @school_class
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update'" do
    describe "for non-signed users" do
      it "should deny access to update school class" do
        class_code = "111"
        put :update, :id => @school_class, 
                     :school_class => @school_class.attributes.merge(:class_code => class_code) 
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i             
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to edit school class" do
        class_code = "111"
        put :update, :id => @school_class, 
                     :school_class => @school_class.attributes.merge(:class_code => class_code)
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should update school class if params are correct" do
        class_code = "111"
        put :update, :id => @school_class, 
                     :school_class => @school_class.attributes.merge(:class_code => class_code)
        @school_class.reload
        @school_class.class_code.should == class_code
      end
      
      it "should reject to update school class if params aren't correct" do
        class_code = "1111"
        put :update, :id => @school_class, 
                     :school_class => @school_class.attributes.merge(:class_code => class_code)
        @school_class.reload
        @school_class.class_code.should_not == class_code
      end
    end
  end
end
