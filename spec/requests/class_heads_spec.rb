# encoding: UTF-8
require 'spec_helper'

describe "ClassHeads" do
  before(:each) do 
           
    # In event controller we get school class code for teacher_leader.
    # So here we do a trick. We create teacher leader via school class and make it's
    # user's role class_head.
    school_class = FactoryGirl.create( :school_class )    
    @ch = school_class.teacher_leader.user
    @ch.user_role = "class_head"
    @ch.save
    
    @everpresent_field_placeholder = "Обязательное поле"
  end
  
  describe "sign in/out" do
    describe "failure" do
      it "should not sign a user in if user login/pass incorrect" do
        visit signin_path
        fill_in "Логин",  :with => ""
        fill_in "Пароль", :with => ""
        click_button "Войти"
         
        response.should have_selector("div.alert.alert-error", 
          :content => "Не удается войти. Пожалуйста, проверьте правильность написания " + 
                      "логина и пароля. Проверьте, не нажата ли клавиша CAPS-lock.")
      end
    end
    
    describe "success" do
      it "should sign a user in and out" do        
        visit signin_path
        fill_in "Логин",  :with => @ch.user_login
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
      fill_in "Логин",  :with => @ch.user_login
      fill_in "Пароль", :with => "foobar"
      click_button "Войти"
    end
    
    it "should have correct links in toolbar with active states" do      
      # State of button when user log-in 
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Мероприятия')
      end
      
      click_link "Мероприятия" 
           
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Мероприятия')
      end
    end
  end
end
