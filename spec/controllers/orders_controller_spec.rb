# encoding: UTF-8
require 'spec_helper'

describe OrdersController do
  render_views
  
  before(:each) do
    @adm = FactoryGirl.create( :user )
    @adm.user_role = "admin"
    @adm.save!
    
    @sh = FactoryGirl.create( :user )
    @sh.user_role = "school_head"
    @sh.save!
    
    @order = FactoryGirl.create( :order )
  end
  
  describe "GET 'index'" do
    describe "for non-signed users" do
      it "should deny access to show orders" do
        get :index
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show orders" do
        get :index
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show orders" do
        get :index
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "GET 'new'" do
    describe "for non-signed users" do
      it "should deny access to show creating order's page" do
        get :new
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access to show creating order's page" do
        get :new
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
  
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should show orders" do
        get :new
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "POST 'create'" do
    describe "for non-signed users" do
      it "should deny access" do
        post :create, :order => @order.attributes.merge( :text_of_order => "some" )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
      
      it "should not create order" do
        expect do
          post :create, :order => @order.attributes.merge(:text_of_order => "some" )
        end.should_not change( Order, :count )
      end
    end
    
    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access" do
        post :create, :order => @order.attributes.merge( :text_of_order => "some" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
      
      it "should not create order" do
        expect do
          post :create, :order => @order.attributes.merge(:text_of_order => "some" )
        end.should_not change( Order, :count )
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should create order" do
        expect do
          post :create, :order => @order.attributes.merge(:text_of_order => "some" )
        end.should change( Order, :count ).by( 1 )
      end
      
      it "should not create order with wrong params" do
        expect do
          post :create, :order => @order.attributes.merge(:text_of_order => " " )
        end.should_not change( Order, :count )
      end
    end
  end

  describe "GET 'edit'" do
    describe "for non-signed users" do
      it "should deny access" do
        get :edit, :id => @order
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signin-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access" do
        get :edit, :id => @order
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for sign-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should allow to edit orders" do
        get :edit, :id => @order
        response.should be_success
        flash[:error].should be_nil
      end
    end
  end

  describe "PUT 'update" do
    describe "for non-signed users" do
      it "should deny access" do
        put :update, :id => @order, 
                     :order => @order.attributes.merge(:text_of_order => "some" )
        response.should redirect_to( signin_path )
        flash[:notice].should =~ /войдите в систему как завуч/i
      end
    end
    
    describe "for signed-in admins" do
      before(:each) do
        test_sign_in( @adm )
      end
      
      it "should deny access" do
        put :update, :id => @order, 
                     :order => @order.attributes.merge(:text_of_order => "some" )
        response.should redirect_to( pages_wrong_page_path )
        flash[:error].should =~ /вы не можете увидеть эту страницу/i
      end
    end
    
    describe "for signed-in school-heads" do
      before(:each) do
        test_sign_in( @sh )
      end
      
      it "should reject to update order with wrong params" do
        text = "  "
        put :update, :id => @order, 
                     :order => @order.attributes.merge(:text_of_order => text )
        @order.reload
        @order.text_of_order.should_not == text
      end
      
      it "should update order with correct params" do
        text = "last"
        put :update, :id => @order, 
                     :order => @order.attributes.merge(:text_of_order => text )
        @order.reload
        @order.text_of_order.should == text
      end
    end      
  end
end
