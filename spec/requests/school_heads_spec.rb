# encoding: UTF-8
require 'spec_helper'

describe "SchoolHeads" do
  before(:each) do
    @attr = {
              :user_login => "iSchool_head",
              :password => "foobar"
            }
    
    user = User.new( @attr )
    user.user_role = "school_head"
    user.save!
    
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
          :content => "Не удается войти. Пожалуйста, проверьте правильность написания логина и пароля. Проверьте, не нажата ли клавиша CAPS-lock.")
      end
    end
    
    describe "success" do
      it "should sign a user in and out" do        
        visit signin_path
        fill_in "Логин",  :with => @attr[:user_login]
        fill_in "Пароль", :with => @attr[:password]
        click_button "Войти"
        
        controller.should be_signed_in       
        click_link "Выход"
        controller.should_not be_signed_in
      end
    end
  end
  
  describe "for sign-in school heads" do
    before(:each) do        
      visit signin_path
      fill_in "Логин",  :with => @attr[:user_login]
      fill_in "Пароль", :with => @attr[:password]
      click_button "Войти"
    end
    
    it "should have correct links in toolbar with active states" do
      # State of button when user log-in 
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Ученики')
      end
           
      click_link "Ученики" 
           
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Ученики')
      end
      
      click_link "Предметы"
      
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Предметы')
      end
      
      click_link "Учителя"
      
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Учителя')
      end
    end
  
    describe "Subject creation" do
      describe "success" do
        before(:each) do
          click_link "Предметы" 
          click_link "Создать"
        end
        
        it "should create subject" do
          expect do 
            response.body.should have_selector('legend', :content => 'Создание предмета')

            fill_in "Имя предмета", :with => "Химия"      
            click_button "Создать"

            response.body.should have_selector('legend', :content => 'Список предметов')
          end.should change(Subject, :count).by(1)
        end
        
        it "should have placeholders for everprecent attributes" do
          response.should have_selector('form') do |form|
            form.should have_selector( 'input', 
                                       :id => 'subject_subject_name',        
                                       :placeholder => @everpresent_field_placeholder )
          end  
        end
        
        it "should keep data in form" do
          fill_in "Имя предмета", :with => "  "
          
          click_button "Создать"
            
          response.should have_selector('form') do |form|
            form.should have_selector( 'input', 
                                       :id => 'subject_subject_name', 
                                       :value => "  " )
          end  
        end
      end
    end
  end
end
