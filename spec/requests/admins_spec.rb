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
  
  describe "for sign-in admin" do 
    before(:each) do  
      user = Factory(:user, :user_login => "user login")
      visit signin_path
      fill_in "Логин",  :with => user.user_login
      fill_in "Пароль", :with => user.password
      click_button "Войти"
    end
      
    it "should have correct links in toolbar with active states" do      
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
    
    it "should redirect from root path to users list" do      
      visit signin_path
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Список учетных записей системы')
      end                                           
    end
    
    describe "Creating school head" do
     it "should visit list of users after creating school head" do
        click_link "Создать учетную запись"
        click_link "Завуч"
        response.should have_selector('legend', :content => 'Создание учетной записи Завуча')
        
        fill_in "Логин учетной записи",  :with => "user.user_login"
        fill_in "Пароль учетной записи", :with => "user.password"
        click_button "Создать"
        response.should have_selector('legend', :content => 'Список учетных записей системы')       
     end
     
     it "should keep values in forms after submit with wrong values and should not create user" do
        lambda do
          user_login, wrong_user_pas = "login", "pas"
        
          click_link "Учетные записи"
          click_link "Создать учетную запись"
          click_link "Завуч"
        
          fill_in "Логин учетной записи",  :with => user_login
          fill_in "Пароль учетной записи", :with => wrong_user_pas
          click_button "Создать"
        
          response.should have_selector("legend", 
                                        :content => "Создание учетной записи Завуча")     # We stay on this page because we have wrong value in form 
          response.should have_selector("form") do |form|
            form.should have_selector( "input", :value => user_login )
            form.should have_selector( "input", :value => wrong_user_pas  )
          end
        end.should_not change(User, :count)
     end
    end
    
    describe "Creating teacher" do
      before(:each) do
        @teacher_surname     = 'Klukin'
        @teacher_name        = 'Petr'
        @teacher_middle_name = 'Ivanovich'
        @teacher_birth       = '24.12.1991'
        @teacher_category    = 'First category'
        @user_login          = 'login'
      end
      
      it "should create teacher with valid data" do
        lambda do
          lambda do 
            user_pas = 'password'
        
            click_link 'Создать учетную запись'
            click_link 'Учитель'
            response.should have_selector( 'legend', 
                                           :content => 'Создание учетной записи Учителя' )
    
            fill_in 'Фамилия',               :with => @teacher_surname
            fill_in 'Имя',                   :with => @teacher_name
            fill_in 'Отчество',              :with => @teacher_middle_name
            choose 'Мужской'                                                              # Choose radio button
            fill_in 'Дата рождения',         :with => @teacher_birth
            fill_in 'Категория',             :with => @teacher_category
            fill_in 'Логин учетной записи',  :with => @user_login
            fill_in 'Пароль учетной записи', :with => user_pas
            click_button 'Создать'
        
            response.should have_selector('legend', 
                                          :content => 'Список учетных записей системы')
          end.should change(User, :count).by(1)
        end.should change(Teacher, :count).by(1) 
      end
      
      it "should keep values in forms after submit with wrong values" do
        lambda do
          lambda do
            wrong_user_pas = 'pas'
        
            click_link 'Создать учетную запись'
            click_link 'Учитель'
            response.should have_selector( 'legend', 
                                           :content => 'Создание учетной записи Учителя' )
        
            fill_in 'Фамилия',               :with => @teacher_surname
            fill_in 'Имя',                   :with => @teacher_name
            fill_in 'Отчество',              :with => @teacher_middle_name
            choose 'Мужской'                                                              # Choose radio button
            fill_in 'Дата рождения',         :with => @teacher_birth
            fill_in 'Категория',             :with => @teacher_category
            fill_in 'Логин учетной записи',  :with => @user_login
            fill_in 'Пароль учетной записи', :with => wrong_user_pas
            click_button 'Создать'
        
            response.should have_selector( 'legend', 
                                           :content => 'Создание учетной записи Учителя' )
            response.should have_selector('form') do |form|
              form.should have_selector( 'input', :value => @teacher_surname )
              form.should have_selector( 'input', :value => @teacher_name )
              form.should have_selector( 'input', :value => @teacher_middle_name )
              form.should have_selector( 'input', :value => @teacher_birth )
              form.should have_selector( 'input', :value => @teacher_category )
              form.should have_selector( 'input', :value => @user_login )
              form.should have_selector( 'input', :value => wrong_user_pas  )
              form.should have_selector( 'input', :value => 'm', :checked => 'checked'  )     # In DB 'w' is woman, 'm' is man thats why we keep such letters in view. 
            end
          end.should_not change(User, :count)
        end.should_not change(Teacher, :count)
      end
    end
  end  
end
