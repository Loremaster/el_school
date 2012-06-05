# encoding: UTF-8
require 'spec_helper'

describe "Pupils" do
  before(:each) do
    pupil = FactoryGirl.create( :pupil )
    pupil.user.user_role = "pupil"
    pupil.user.save!

    @pupil = pupil.user
  end

  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in with invalid password" do
        visit signin_path
        fill_in "Логин",  :with => ""
        fill_in "Пароль", :with => ""
        click_button "Войти"

        controller.should_not be_signed_in

        response.should have_selector("div.alert.alert-error",
          :content => "Не удается войти. Пожалуйста, проверьте правильность написания " +
                      "логина и пароля. Проверьте, не нажата ли клавиша CAPS-lock.")
      end
    end

    describe "success" do
      it "should sign a user in and out" do
        visit signin_path
        fill_in "Логин",  :with => @pupil.user_login
        fill_in "Пароль", :with => "foobar"
        click_button "Войти"

        controller.should be_signed_in
        click_link "Выход"
        controller.should_not be_signed_in
      end
    end
  end

  describe "for sign-in pupils" do
    before(:each) do
      visit signin_path
      fill_in "Логин",  :with => @pupil.user_login
      fill_in "Пароль", :with => "foobar"
      click_button "Войти"
    end

    describe "Toolbar" do
      it "should have correct links in toolbar with active states" do
        # State of button when user log-in
        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Успеваемость')
        end

        click_link 'Успеваемость'

        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Успеваемость')
        end
      end
    end
  end
end