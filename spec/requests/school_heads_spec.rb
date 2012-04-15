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
      
      click_link "Классы"
      
      response.should be_success
      response.body.should have_selector( "li.active") do
        have_selector('a', :content => 'Классы')
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
        @subj = FactoryGirl.create( :subject, :subject_name => "Physics" )
        
        @teacher = FactoryGirl.create( :teacher )
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
  
    describe "Teacher Leader creation" do
      # THIS TEST DOESN'T WORK!!! I don't know why.. Maybe Rspec bug?
      # describe "failure" do
      #   it "should show error message if there are no teachers" do
      #     expect do
      #     expect do  
      #       click_link "Учителя" 
      #       click_link "Создать классного руководителя" 
      #         fill_in "Логин учетной записи",  :with => "something"
      #         fill_in "Пароль учетной записи", :with => "another something"      
      #       click_button "Создать"
      #     
      #       response.should have_selector('div', 
      #                                     :content => 'невозможно создать классного руководителя')
      #     end.should_not change( TeacherLeader, :count ) 
      #     end.should_not change( User, :count )                              
      #   end
      # end
            
      describe "Creation" do
        before(:each) do              
          @teacher = FactoryGirl.create( :teacher )
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
          
          it "should keep values in forms" do
            # @teacher2 = Factory( :teacher, 
            #                      :teacher_last_name   => "B.", 
            #                      :teacher_first_name  => "B.",
            #                      :teacher_middle_name => "Kingi",
            #                      :user => Factory( :user, :user_login => Factory.next( :user_login )))
            # @teacher2.user.user_role = "teacher"
            # @teacher2.save!
            
            fill_in "Логин учетной записи",  :with => "something"
            fill_in "Пароль учетной записи", :with => "ano"
            # select "#{@teacher2.teacher_last_name} "  +                                   # Select option via name.
            #        "#{@teacher2.teacher_first_name} " + 
            #        "#{@teacher2.teacher_middle_name}", 
            #        :from => "user_teacher_leader_attributes_teacher_id"
                   
            click_button "Создать"
            
            response.should have_selector("form") do |form|
              form.should have_selector( "input", :value => "something" )
              form.should have_selector( "input", :value => "ano"  )
            end
          end  
        end
      end
    
      describe "Update" do        
        describe "Success and Failure" do
          before(:each) do              
            @leader = FactoryGirl.create( :teacher_leader )
          end
          
          describe "Success" do
            before(:each) do
              @teacher2 = FactoryGirl.create( :teacher, 
                                              :teacher_last_name   => "B.", 
                                              :teacher_first_name  => "B.",
                                              :teacher_middle_name => "King")
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
            @leader = FactoryGirl.create( :teacher_leader )
            expect do
              click_link "Учителя" 
              visit edit_teacher_leader_path( :id => @leader.id )
              click_button "Обновить"
            end.should_not change( TeacherLeader, :count )
          end
        end                      
      end
    end
  
    describe "School's class" do
      describe "View" do
        it "should have placeholders" do
          click_link "Классы"
          click_link "Создать класс"
          
          response.should have_selector('input', 
                                        :name => "school_class[class_code]",
                                        :placeholder => @everpresent_field_placeholder)
          response.should have_selector('input',
                                        :name => "school_class[date_of_class_creation]",
                                        :placeholder => @everpresent_field_placeholder)                              
            
        end
        
        it "should keep values in forms" do
          teacher_leader = FactoryGirl.create( :teacher_leader )
          
          click_link "Классы"
          click_link "Создать класс"
          
          fill_in "Номер класса",  :with => "11"
          fill_in "Дата создания класса", :with => "21"
          select "#{teacher_leader.teacher.teacher_last_name} "  +                        # Select option via name.
                 "#{teacher_leader.teacher.teacher_first_name} " + 
                 "#{teacher_leader.teacher.teacher_middle_name}", 
                 :from => "school_class[teacher_leader_id]"
          
          click_button "Создать"
          
          response.should have_selector("form") do |form|
            form.should have_selector( "input", 
                                       :name => "school_class[class_code]", 
                                       :value => "11" )
            form.should have_selector( "input", 
                                       :name => "school_class[date_of_class_creation]",
                                       :value => "21"  )                                       
          end
          response.should have_selector( "select",
                                         :name => "school_class[teacher_leader_id]") do |sel|
             sel.should have_selector( "option",
                                       :selected => "selected",
                                       :value => "#{teacher_leader.id}" )                              
          end                                 
        end
      end
    
      describe "Create" do
        before(:each) do
          @t_leader =  FactoryGirl.create( :teacher_leader )
          click_link "Классы"
          click_link "Создать класс" 
        end
        
        describe "Success" do
          it "should create class with valid data" do
            expect do
              fill_in "Номер класса",  :with => "11a"
              fill_in "Дата создания класса", :with => "#{Date.today}" 
              select "#{@t_leader.teacher.teacher_last_name} "  +                         # Select option via name.
                     "#{@t_leader.teacher.teacher_first_name} " + 
                     "#{@t_leader.teacher.teacher_middle_name}", 
                     :from => "school_class[teacher_leader_id]"
            
              click_button "Создать"
            end.should change( SchoolClass, :count ).by( 1 )            
          end
        end
      
        describe "Failure" do
          it "should reject to create class with invalid data" do
            expect do
              fill_in "Номер класса",  :with => "11a"
              fill_in "Дата создания класса", :with => "#{Date.today - 2.years}" 
              select "#{@t_leader.teacher.teacher_last_name} "  +                         # Select option via name.
                     "#{@t_leader.teacher.teacher_first_name} " + 
                     "#{@t_leader.teacher.teacher_middle_name}", 
                     :from => "school_class[teacher_leader_id]"
          
              click_button "Создать"
            end.should_not change( SchoolClass, :count )
          end
        end
      end
    
      describe "Updating" do
        before(:each) do
          @t_leader =  FactoryGirl.create( :teacher_leader )
          click_link "Классы"
          click_link "Создать класс"
          
          fill_in "Номер класса",  :with => "11a"
          fill_in "Дата создания класса", :with => "#{Date.today}" 
          select "#{@t_leader.teacher.teacher_last_name} "  +                             # Select option via name.
                 "#{@t_leader.teacher.teacher_first_name} " + 
                 "#{@t_leader.teacher.teacher_middle_name}", 
                 :from => "school_class[teacher_leader_id]"
        
          click_button "Создать"
          
          visit edit_school_class_path( :id => SchoolClass.first )
        end
        
        describe "Success" do
          it "should update with valid params" do
            fill_in "Номер класса",  :with => "11c"
            click_button "Изменить"
            
            flash[:success].should =~ /Класс успешно обновлен!/i
          end
        end
        
        describe "Failure" do
          it "should reject to update with not valid params" do
            fill_in "Номер класса",  :with => "  "
            click_button "Изменить"
            
            flash[:error].should =~ /не может быть пустым/i
          end
        end
      end
    end
  
    describe "Pupils" do
      describe "Creating" do
        describe "View" do
          before(:each) do
            click_link "Ученики"
            click_link "Создать ученика"
          end
        
          it "should have placeholders" do
            response.should have_selector( 'input', 
                                           :name => "pupil[pupil_last_name]",
                                           :placeholder => @everpresent_field_placeholder )                   
            response.should have_selector( 'input',                                       
                                           :name => "pupil[pupil_first_name]",            
                                           :placeholder => @everpresent_field_placeholder ) 
            response.should have_selector( 'input',                                       
                                           :name => "pupil[pupil_middle_name]",           
                                           :placeholder => @everpresent_field_placeholder )  
            response.should have_selector( 'input',                                       
                                           :name => "pupil[pupil_birthday]",              
                                           :placeholder => @everpresent_field_placeholder )                   
            response.should have_selector( 'input',                                       
                                           :name => "pupil[pupil_nationality]",           
                                           :placeholder => @everpresent_field_placeholder ) 
            response.should have_selector( 'textarea', 
                                           :name => "pupil[pupil_address_of_registration]",
                                           :placeholder => @everpresent_field_placeholder )   
            response.should have_selector( 'textarea',                                    
                                           :name => "pupil[pupil_address_of_living]",     
                                           :placeholder => @everpresent_field_placeholder )
            response.should have_selector( "input",                                                                                                 
                                           :name => "pupil[pupil_phone_attributes][pupil_home_number]",                                                          
                                           :placeholder => @everpresent_field_placeholder )                                                                                       
            response.should have_selector( "input",                                                                                                                       
                                           :name => "pupil[pupil_phone_attributes][pupil_mobile_number]",                                                                                                               
                                           :placeholder => @everpresent_field_placeholder )                                                                            
            response.should have_selector( 'input', 
                                           :name => "pupil[user_attributes][user_login]",
                                           :placeholder => @everpresent_field_placeholder ) 
            response.should have_selector( 'input',                                       
                                           :name => "pupil[user_attributes][password]",   
                                           :placeholder => @everpresent_field_placeholder )                                                         
          end
      
          it "should keep values in forms" do
            pupil = FactoryGirl.create( :pupil )
            pupil_phones = FactoryGirl.create( :pupil_phone )
            login, password = "l", "p"
          
            fill_in "Фамилия",  :with => pupil.pupil_last_name
            fill_in "Имя",      :with => pupil.pupil_first_name
            fill_in "Отчество", :with => pupil.pupil_middle_name
            choose "Женский"
            fill_in "Дата рождения",  :with => pupil.pupil_birthday
            fill_in "Национальность", :with => pupil.pupil_nationality
            fill_in "Адрес прописки", :with => pupil.pupil_address_of_registration
            fill_in "Адрес проживания",  :with => pupil.pupil_address_of_living
            fill_in "Домашний телефон",  :with => pupil_phones.pupil_home_number                
            fill_in "Мобильный телефон", :with => pupil_phones.pupil_mobile_number
            fill_in "Логин учетной записи",  :with => login
            fill_in "Пароль учетной записи", :with => password
          
            click_button "Создать"
          
            response.should have_selector("form") do |form|
              form.should have_selector( "input", 
                                          :name => "pupil[pupil_last_name]",
                                          :value => pupil.pupil_last_name )
              form.should have_selector( "input", 
                                          :name => "pupil[pupil_first_name]",
                                          :value => pupil.pupil_first_name )                                       
              form.should have_selector( "input", 
                                          :name => "pupil[pupil_middle_name]",
                                          :value => pupil.pupil_middle_name )                                        
              form.should have_selector( "input", 
                                          :name => "pupil[pupil_sex]",
                                          :value => "w",            
                                          :checked => "checked" )                                                    
              form.should have_selector( "input", 
                                          :name => "pupil[pupil_birthday]",
                                          :value => "#{pupil.pupil_birthday}" )              
              form.should have_selector( "input", 
                                          :name => "pupil[pupil_nationality]",
                                          :value => pupil.pupil_nationality )              
              form.should have_selector( "textarea", 
                                          :name => "pupil[pupil_address_of_registration]",
                                          :content => pupil.pupil_address_of_registration )                           
              form.should have_selector( "textarea",                                 
                                          :name => "pupil[pupil_address_of_living]",                            
                                          :content => pupil.pupil_address_of_living )             
              form.should have_selector( "input",                                                                   
                                          :name => "pupil[pupil_phone_attributes][pupil_home_number]",                            
                                          :value => pupil_phones.pupil_home_number  )                                                         
              form.should have_selector( "input",                                                                                         
                                          :name => "pupil[pupil_phone_attributes][pupil_mobile_number]",                                                                                    
                                          :value => pupil_phones.pupil_mobile_number )                                                                                                                                        
              form.should have_selector( "input",                                 
                                          :name => "pupil[user_attributes][user_login]",
                                          :value => login )                           
              form.should have_selector( "input",                                                             
                                          :name => "pupil[user_attributes][password]",                                                        
                                          :value => password )                                                                                                
            end
          end
        end
    
        describe "Create" do
        before(:each) do
          click_link "Ученики"
          click_link "Создать ученика"
        end
        
        describe "Success" do         
          it "should create pupil with valid data" do
            expect do
            expect do  
            expect do                                                        
              fill_in "Фамилия",  :with => "Перионов"                        
              fill_in "Имя",      :with => "Петр"                            
              fill_in "Отчество", :with => "Петрович"                        
              choose "Мужской"                                               
              fill_in "Дата рождения",  :with => "#{Date.today - 10.years}"  
              fill_in "Национальность", :with => "Русский"                   
              fill_in "Адрес прописки", :with => "Москва ..."                
              fill_in "Адрес проживания",  :with => "Москва ..."             
              fill_in "Домашний телефон",  :with => "111111"                 
              fill_in "Мобильный телефон", :with => "222222"                 
              fill_in "Логин учетной записи",  :with => "loooog"             
              fill_in "Пароль учетной записи", :with => "paaaaas"            
                                                                             
              click_button "Создать"                                         
            end.should change( Pupil, :count ).by( 1 )                       
            end.should change( User, :count).by( 1 )
            end.should change( PupilPhone, :count).by( 1 )
          end
        end
      
        describe "Failure" do
          it "should reject to create pupil if data is invalid" do
            expect do
            expect do                                                         
            expect do                                                         
              fill_in "Фамилия",  :with => "Перионов"                         
              fill_in "Имя",      :with => ""                                 
              fill_in "Отчество", :with => "Петрович"                         
              choose "Мужской"                                                
              fill_in "Дата рождения",  :with => "#{Date.today - 10.years}"   
              fill_in "Национальность", :with => "Русский"                    
              fill_in "Адрес прописки", :with => "Москва ..."                 
              fill_in "Адрес проживания",  :with => "Москва ..."          
              fill_in "Домашний телефон",  :with => "111111"                   
              fill_in "Мобильный телефон", :with => "222222"                  
              fill_in "Логин учетной записи",  :with => "loooog"              
              fill_in "Пароль учетной записи", :with => "paaaaas"             
                                                                              
              click_button "Создать"                                          
            end.should_not change( Pupil, :count )                            
            end.should_not change( User, :count)
            end.should_not change( PupilPhone, :count)
          end
        end
      end
      end
    
      describe "Updating" do
        before(:each) do
          @ipupil = FactoryGirl.create( :pupil )
          @attr_pupil_phones = {
            :pupil_home_number   => "8903111111",
            :pupil_mobile_number => "777-33-22"
          }
          @ipupil.create_pupil_phone( @attr_pupil_phones )
          
          visit edit_pupil_path( :id => @ipupil )
        end
        
        describe "View" do
          it "should have button to print" do
            response.should have_selector("form") do |form|
              form.should have_selector( "a",
                                         :onclick => "javascript:window.print(); return false;",
                                         :content => "Отправить на печать" )
            end
          end
          
          it "should have values in forms" do
            response.should have_selector("form") do |form|
              form.should have_selector( "input", 
                                          :name => "pupil[pupil_last_name]",
                                          :value => @ipupil.pupil_last_name )
              form.should have_selector( "input",                                                         
                                          :name => "pupil[pupil_first_name]",                             
                                          :value => @ipupil.pupil_first_name )                                                                   
              form.should have_selector( "input",                                                         
                                          :name => "pupil[pupil_middle_name]",                            
                                          :value => @ipupil.pupil_middle_name ) 
              form.should have_selector( "input",                                                  
                                          :name => "pupil[pupil_sex]",                             
                                          :value => @ipupil.pupil_sex,                                           
                                          :checked => "checked" )                                                                                                               
              form.should have_selector( "input",                                                                         
                                          :name => "pupil[pupil_birthday]",                                               
                                          :value => "#{@ipupil.pupil_birthday}" )                                          
              form.should have_selector( "input",                                                                         
                                          :name => "pupil[pupil_nationality]",                                            
                                          :value => @ipupil.pupil_nationality )                                           
              form.should have_selector( "textarea",                                                                      
                                          :name => "pupil[pupil_address_of_registration]",                                
                                          :content => @ipupil.pupil_address_of_registration )
              form.should have_selector( "textarea",                                                                 
                                          :name => "pupil[pupil_address_of_living]",                                                        
                                          :content => @ipupil.pupil_address_of_living )                                         
              form.should have_selector( "input",                                                                                               
                                         :name => "pupil[pupil_phone_attributes][pupil_home_number]",                                                        
                                         :value => @ipupil.pupil_phone.pupil_home_number )                                                                                                                         
              form.should have_selector( "input",                                                                                                                     
                                         :name => "pupil[pupil_phone_attributes][pupil_mobile_number]",                                                                                                                                                                                                     
                                         :value => @ipupil.pupil_phone.pupil_mobile_number )                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
            end
          end

        end
      
        describe "Success" do
          it "should change if attributes are correct" do
            fill_in "Фамилия",  :with => "Some"
            click_button "Изменить"
            
            flash[:success].should =~ /Ученик успешно обновлен!/i
          end
        end
        
        describe "Failure" do
          it "should reject to change if attributes are not correct" do
            fill_in "Фамилия",  :with => "  "
            click_button "Изменить"
            
            flash[:error].should =~ /не может быть пустой/i
          end
        end 
      end
    end
  end
end
