# encoding: UTF-8
require 'spec_helper'

describe AdminsController do
  render_views

  describe "GET 'users_of_system'" do
    describe "for non-signed-in as admin users" do
      it "should deny access to admin's pages" do
        admin_pages = %w(backups new_school_head new_teacher create_school_head create_teacher)
        admin_pages.each do |admin_pg|
          get admin_pg
          response.should redirect_to( signin_path )
          flash[:notice].should =~ /войдите в систему как администратор/i
        end
      end
    end
  end

  describe "for signed-in as admin users" do
    before(:each) do
      @user = FactoryGirl.create(:user)
      test_sign_in( @user )
    end

    it "should have legend for backups page" do
      get :backups
      response.should have_selector("legend", :content => "Бэкапы")
    end

    describe "POST 'create school head'" do
      before(:each) do
        @attr_correct = {
                          :user_login => "School",
                          :user_role => "school_head",
                          :password => "qwerty"
                        }
        @attr_wrong =   {
                          :user_login => "",
                          :user_role => "",
                          :password => ""
                        }
      end

      it "should have legend" do
        get :new_school_head
        response.should have_selector("legend", :content => "Создание учетной записи Заместителя директора по учебной работе")
      end

      it "should create school head with valid data" do
        expect do
          post :create_school_head, :user => @attr_correct
        end.should change(User, :count).by(1)
      end

      it "should not create school head with invalid data" do
        expect do
          post :create_school_head, :user => @attr_wrong
        end.should_not change(User, :count)
      end

      it "should show success message if class head has been created" do
        post :create_school_head, :user => @attr_correct
        flash[:success].should_not be_nil
      end
    end
  end
end

