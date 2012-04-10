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
  
    describe "Teacher-Subjects (Qualification) creation" do
      before(:each) do
        @subj = Factory( :subject, :subject_name => "Physics" )
        
        @teacher = Factory( :teacher )
        @teacher.user.user_role = "teacher"
        @teacher.save!
      end
      
      it "should change subjects for teacher (qualification) if checkbox checked and unchecked" do
        expect do
          visit edit_teacher_path( :id => @teacher.id )
        
          # Checking that we have in one table row label and that checkbox still unchecked.
          response.should have_selector( 'tr' ) do |tr|
            tr.should have_selector( 'td' ) do |td|
              td.should have_selector( 'label', :content => "Physics" )
            end
            tr.should have_selector( 'td' ) do |td| 
              td.should_not have_selector( 'input', :checked => "checked" )
            end
          end
        
          check "Physics"       
          click_button "Обновить"
        end.should change( Qualification, :count ).by( 1 ) 
        
        expect do
          visit edit_teacher_path( :id => @teacher.id )
        
          # Checking that we have in one table row label and that checkbox've checked.
          response.should have_selector( 'tr' ) do |tr|
            tr.should have_selector( 'td' ) do |td|
              td.should have_selector( 'label', :content => "Physics" )
            end
            tr.should have_selector( 'td' ) do |td| 
               td.should have_selector( 'input', :checked => "checked" )
            end
          end  
        
          uncheck "Physics"       
          click_button "Обновить"
        end.should change( Qualification, :count ).by( -1 )
      end
    end
  
    describe "Teacher Leader" do
      describe "Creation failure" do
        # it "should show error message if there are no teachers" do
        #   click_link "Учителя" 
        #   click_link "Создать классного руководителя"
        #   
        #   # fill_in "Логин учетной записи",  :with => "My login"
        #   # fill_in "Пароль учетной записи", :with => "My password"          
        #   click_button "Создать"
        #   
        #   response.should have_selector('flash', 
        #                                 :content => 'невозможно создать классного руководителя') 
        # end
      end
            
      describe "Creation" do
        before(:each) do              
          @teacher = Factory( :teacher )
          @teacher.user.user_role = "teacher"
          @teacher.save!
        end
             
        describe "Success" do
          before(:each) do
            click_link "Учителя" 
            click_link "Создать классного руководителя"
          end
        
          it "should create teacher leader" do
            expect do
              fill_in "Логин учетной записи",  :with => "My login"
              fill_in "Пароль учетной записи", :with => "My password"
          
              click_button "Создать"
            
              response.should have_selector('legend', 
                                            :content => 'Список классных руководителей')
            end.should change( TeacherLeader, :count ).by( 1 )
          end       
        end
    
        describe "Failure" do
          before(:each) do
            click_link "Учителя" 
            click_link "Создать классного руководителя"
          end
        
          it "should not create teacher leader with empty data" do
            expect do
              fill_in "Логин учетной записи",  :with => "  "
              fill_in "Пароль учетной записи", :with => "  "
          
              click_button "Создать"
            
              response.should have_selector('legend', 
                                            :content => 'Создание классного руководителя')
            end.should_not change( TeacherLeader, :count )
          end
        
          it "should not create teacher leader if he already exists" do                     # It should not create teacher leader because select already has same option.
            fill_in "Логин учетной записи",  :with => "something"
            fill_in "Пароль учетной записи", :with => "another something"
        
            click_button "Создать"
          
            expect do
              click_link "Учителя" 
              click_link "Создать классного руководителя"
          
              fill_in "Логин учетной записи",  :with => "something2"
              fill_in "Пароль учетной записи", :with => "another something"
            
              response.should have_selector('legend', 
                                            :content => 'Создание классного руководителя')
            end.should_not change( TeacherLeader, :count )
          end  
        end
      end
    
      describe "Update" do        
        describe "Success and Failure" do
          before(:each) do              
            @teacher = Factory( :teacher )
            @teacher.user.user_role = "teacher"
            @teacher.save!
             
            @user = Factory( :user, :user_login => Factory.next(:user_login) )
            @user.user_role = "class_head"
            @user.save!
             
            @leader = @user.create_teacher_leader({ :user_id => @user.id, :teacher_id => @teacher.id })
          end
          
          describe "Success" do
            before(:each) do
              @teacher2 = Factory( :teacher, 
                                   :teacher_last_name   => "B.", 
                                   :teacher_first_name  => "B.",
                                   :teacher_middle_name => "King",
                                   :user => Factory( :user, :user_login => Factory.next( :user_login )))
              @teacher2.user.user_role = "teacher"
              @teacher2.save!
              
              click_link "Учителя" 
              visit edit_teacher_leader_path( :id => @leader.id )  
            end
            
            it "should save another teacher as teacher leader instead of current teacher leader and should show it in lists of class heads" do
              select "#{@teacher2.teacher_last_name} "  +                                 # Select option via name.
                     "#{@teacher2.teacher_first_name} " + 
                     "#{@teacher2.teacher_middle_name}", 
                     :from => "teacher_leader[teacher_id]"
             
              click_button "Обновить"
              
              response.should have_selector('legend', 
                                            :content => 'Список классных руководителей')
              
              # Checking that new class head appear in list of class heads.                              
              response.should have_selector( 'table', :name => "class_heads" ) do |table|
                table.should have_selector('tbody') do |tbody|
                  tbody.should have_selector('tr') do |td|
                    td.should contain( @teacher2.teacher_last_name )
                    td.should contain( @teacher2.teacher_first_name )
                    td.should contain( @teacher2.teacher_middle_name )
                  end
                end
              end                                       
            end
          end          
        end 
        
        describe "Failure" do
          it "should not save same teacher leader" do
            @teacher = Factory( :teacher )
            @teacher.user.user_role = "teacher"
            @teacher.save!
             
            @user = Factory( :user, :user_login => Factory.next(:user_login) )
            @user.user_role = "class_head"
            @user.save!
             
            @leader = @user.create_teacher_leader({ :user_id => @user.id, :teacher_id => @teacher.id })
            
            expect do
              click_link "Учителя" 
              visit edit_teacher_leader_path( :id => @leader.id )
              click_button "Обновить"
            end.should_not change( TeacherLeader, :count )
          end
        end                      
      end
    end
  end
end
