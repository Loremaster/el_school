# encoding: UTF-8
require 'spec_helper'

describe "Teachers" do
  before(:each) do

    # Here we use trick. First of all we create qualification with teacher first and
    # only then we edit it's user to be correct. I found that only this works.
    qualification = FactoryGirl.create( :qualification )
    @t = qualification.teacher.user
    @t.user_role = "teacher"
    @t.save!

    @everpresent_field_placeholder = "Обязательное поле"
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
        fill_in "Логин",  :with => @t.user_login
        fill_in "Пароль", :with => "foobar"
        click_button "Войти"

        controller.should be_signed_in
        click_link "Выход"
        controller.should_not be_signed_in
      end
    end
  end

  describe "for sign-in class heads" do
    before(:each) do
      visit signin_path
      fill_in "Логин",  :with => @t.user_login
      fill_in "Пароль", :with => "foobar"
      click_button "Войти"
    end

    describe "Toolbar" do
      it "should have correct links in toolbar with active states" do
        # State of button when user log-in
        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Журнал')
        end

        click_link "Журнал"
        click_link @t.teacher.subjects.first.subject_name

        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Журнал')
        end
      end
    end
  end
end