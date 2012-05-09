# encoding: UTF-8
require 'spec_helper'

describe "ClassHeads" do
  before(:each) do 
           
    # In event controller we get school class code for teacher_leader.
    # So here we do a trick. We create teacher leader via school class and make it's
    # user's role class_head.
    @school_class = FactoryGirl.create( :school_class )    
    @ch = @school_class.teacher_leader.user
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
    
    describe "Toolbar" do    
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
        
        click_link "Отчеты" 
           
        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Отчеты')
        end
      end
    end
  
    describe "Event" do      
      describe "Creating" do
        describe "View" do
          before(:each) do
            click_link "Мероприятия"
            click_link "Создать"
          end

          it "should have placeholders" do
            inputs_text = [ "event[event_begin_date]", "event[event_end_date]", 
                       "event[event_cost]" ]
            inputs_textarea = [ "event[event_place]", "event[event_place_of_start]" ]
                       
            inputs_text.each do |inp|                                                                    
               response.should have_selector( 'input',                                               
                                              :name => inp,                                          
                                              :placeholder => @everpresent_field_placeholder )        
            end 
            
            inputs_textarea.each do |inp|                                                                    
               response.should have_selector( 'textarea',                                               
                                              :name => inp,                                          
                                              :placeholder => @everpresent_field_placeholder )        
            end          
          end
        end
        
        describe "Create" do
          before(:each) do
            teacher = FactoryGirl.create( :teacher )
            click_link "Мероприятия"
            click_link "Создать"
          end
          
          it "should save event with correct params" do
            expect do
              fill_in "Место проведения мероприятия", :with => "USA"
              fill_in "Место сбора на мероприятие", :with => "Moscow"
              fill_in "Дата начала мероприятия", 
                      :with => "#{Date.today.strftime("%d.%m.%Y")}"
              fill_in "Дата окончания мероприятия", 
                      :with => "#{Date.today.strftime("%d.%m.%Y")}"
              fill_in "Стоимость мероприятия", :with => 0
            
              click_button "Создать"
            end.should change( Event, :count ).by( 1 )
          end 
          
          it "should not save event with invalid params" do
            expect do
              fill_in "Место проведения мероприятия", :with => ""
              fill_in "Место сбора на мероприятие", :with => ""
              fill_in "Дата начала мероприятия",:with => ""
              fill_in "Дата окончания мероприятия", :with => ""
              fill_in "Стоимость мероприятия", :with => -1
            
              click_button "Создать"
            end.should_not change( Event, :count )
          end
        end
      
        describe "Update" do
          before(:each) do
            @event = FactoryGirl.create( :event )
            visit edit_event_path( :id => @event )
          end
          
          it "should update event with valid params" do
            fill_in "Место проведения мероприятия", :with => "USA"
            fill_in "Место сбора на мероприятие", :with => "Moscow"
            fill_in "Дата начала мероприятия", 
                    :with => "#{Date.today.strftime("%d.%m.%Y")}"
            fill_in "Дата окончания мероприятия", 
                    :with => "#{Date.today.strftime("%d.%m.%Y")}"
            fill_in "Стоимость мероприятия", :with => 0
          
            click_button "Обновить"
            
            flash[:success].should =~ /Мероприятие успешно обновлено!/i
          end
          
          it "should not update event with invalid params" do
            fill_in "Место проведения мероприятия", :with => ""
            fill_in "Место сбора на мероприятие", :with => ""
            fill_in "Дата начала мероприятия",:with => ""
            fill_in "Дата окончания мероприятия", :with => ""
            fill_in "Стоимость мероприятия", :with => -1
          
            click_button "Обновить"
            
            flash[:error].should_not be_nil
          end
        end
      end
    end
  
    # describe "ParentMeeting" do
    #       before(:each) do
    #         # Crate meeting for school class.
    #         @meeting = FactoryGirl.create( :meeting )
    #         @meeting.school_class = @school_class
    #         @meeting.save
    #         
    #         # Create pupil and save school_class for him.
    #         @pupil = FactoryGirl.create( :pupil )
    #         @pupil.school_class = @school_class
    #         @pupil.save
    # 
    #         # Create parent and save created pupil for him.
    #         @parent = FactoryGirl.create( :parent )
    #         @parent.pupil_ids = @pupil.id
    #         @parent.save
    #       end
    #       
    #       describe "Choosing parent for scholl  class" do
    #         it "should choose and save parent" do
    #             # visit edit_parents_meeting_path( :id => @meeting )
    #           click_link "Отчеты"
    #           visit edit_parents_meeting_path( :id => @meeting )
    #           puts response.body
    #         end
    #       end
    #     end
    #   
  end

end
