# encoding: UTF-8
require 'spec_helper'

describe "Admins" do
  
  before(:each) do
      @attr = {
                :user_login => "Admin2",
                :user_role => "admin",
                :password => "foobar"
              }
      
      User.create!(@attr)
  end
  
  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in" do
        visit signin_path
        fill_in "Логин",  :with => ""
        fill_in "Пароль", :with => ""
        click_button "Войти" 
        response.should have_selector("div.alert.alert-error", :content => "Не удается войти. Пожалуйста, проверьте правильность написания логина и пароля. Проверьте, не нажата ли клавиша CAPS-lock.")
      end
    end
    
    describe "success" do
      it "should sign a user in and out" do        
        visit signin_path
        fill_in "Логин",  :with => "Admin2"
        fill_in "Пароль", :with => "foobar"
        click_button "Войти"
        
        controller.should be_signed_in       
        click_link "Выход"
        controller.should_not be_signed_in
      end
    end
  end
  
  describe "for sign-in user" do
    it "should have correct links in toolbar with active states" do
      user = Factory(:user)
      visit signin_path
      fill_in "Логин",  :with => user.user_login
      fill_in "Пароль", :with => user.password
      click_button "Войти"
      
      click_link "Резервные копии"
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Бекапы')
      end
      
      
      click_link "Учетные записи"
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Список учетных записей системы')
      end
    end
  end  
end
