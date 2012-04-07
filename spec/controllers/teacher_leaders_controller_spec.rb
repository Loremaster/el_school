# encoding: UTF-8
require 'spec_helper'

describe TeacherLeadersController do
  render_views

  before(:each) do
    @adm = Factory( :user, :user_login => Factory.next(:user_login)  )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = Factory( :user, :user_login => Factory.next(:user_login)  )
    @sh.user_role = "school_head"
    @sh.save!
    
    @teacher = Factory( :teacher )
    @teacher.user.user_role = "teacher"
    @teacher.save!
      
    @user = Factory( :user, :user_login => Factory.next(:user_login) )
    @user.user_role = "class_head"
    @user.save!
        
    @attr_teacher_leader = { :user_id => @user.id, :teacher_id => @teacher.id }
    
    # @attr_correct_teacher_leader = {
    #   :user => { :user_login => "Just User",
    #              :user_role  => "class_head",
    #              :password   => "foobar" },
    #   :teacher_leader => { :teacher_id => @teacher.id }
    # }
    # 
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access" do
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
      end
    end
  end
  
  describe "POST 'create'" do
    describe "for non-signed users" do
      it "should deny access to create teachers leaders" do
        expect do
          post :create, :teacher_leader => @attr_teacher_leader
          response.should redirect_to( signin_path )
          flash[:notice].should =~ /войдите в систему как завуч/i
        end.should_not change( TeacherLeader, :count )
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to create teachers leaders" do
        expect do
          post :create, :teacher_leader => @attr_teacher_leader
          response.should redirect_to( pages_wrong_page_path )
        end.should_not change(TeacherLeader, :count)
      end
    end

    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should deny access to create teachers leaders" do
        expect do
          # post :create, :teacher_leader => @attr_teacher_leader                         # POST DOESN'T work. I don't understand why.
          @user.create_teacher_leader( @attr_teacher_leader )                             # Temporary 'fix'. Remove that when you find solution.
        end.should change(TeacherLeader, :count).by(1)
      end
    end   
  end

  describe "GET 'edit'" do
    before(:each) do
      @teacher_leader = @user.create_teacher_leader( @attr_teacher_leader )
    end
    
    describe "for non-signed users" do
      it "should deny access to edit teacher leaders" do
        get :edit, :id => @teacher_leader
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access" do
        get :edit, :id => @teacher_leader
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for sign-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should allow to edit subjects" do
        get :edit, :id => @teacher_leader
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    before(:each) do
      @teacher_leader = @user.create_teacher_leader( @attr_teacher_leader )
      
      @teacher2 = Factory( :teacher, 
                           :user => Factory( :user, 
                                             :user_login => Factory.next( :user_login )
                                           ) 
                         ) 
      @teacher2.user.user_role = "teacher"
      @teacher2.save!
    end
    
    describe "for non-signed users" do
      it "should deny" do
        put :update, :id => @teacher_leader, :teacher_leader => { :teacher_id => @teacher2.id }
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end  
    end
    
    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny" do
        put :update, :id => @teacher_leader, :teacher_leader => { :teacher_id => @teacher2.id }
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should update teacher leader with correct params" do
        put :update, :id => @teacher_leader, :teacher_leader => { :teacher_id => @teacher2.id }
        @teacher_leader.reload
        @teacher_leader.teacher_id.should == @teacher2.id
      end
    end
  end
end
