# encoding: UTF-8
require 'spec_helper'

describe "Parents" do
  before(:each) do
    # We create user this way because it auto creates school class (controller need that.)
    @pupil = FactoryGirl.create( :pupil )
    @pupil.user.user_role = "pupil"
    @pupil.user.save!

    # Creating parent and link to his child - pupil.
    pp = FactoryGirl.create( :parent_pupil, :pupil_id => @pupil.id )
    pp.parent.user.user_role = "parent"
    pp.parent.user.save!

    @parent = pp.parent.user
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
        fill_in "Логин",  :with => @parent.user_login
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
      fill_in "Логин",  :with => @parent.user_login
      fill_in "Пароль", :with => "foobar"
      click_button "Войти"
    end

    describe "Toolbar" do
      it "should have correct links in toolbar with active states" do
        # State of button when user log-in
        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Родительские собрания')
        end

        click_link 'Родительские собрания'
        click_link "#{@pupil.pupil_last_name} #{@pupil.pupil_first_name} " +
                   "#{@pupil.pupil_middle_name}"

        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Родительские собрания')
        end

        click_link 'Мероприятия'
        click_link "#{@pupil.pupil_last_name} #{@pupil.pupil_first_name} " +
                   "#{@pupil.pupil_middle_name}"

        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Мероприятия')
        end

        click_link 'Успеваемость'
        click_link "#{@pupil.pupil_last_name} #{@pupil.pupil_first_name} " +
                   "#{@pupil.pupil_middle_name}"

        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Успеваемость')
        end
      end
    end

    describe "Meetings" do
      before(:each) do
        @text = "Test!"
        @meeting = FactoryGirl.create( :meeting, :meeting_theme => @text,
                                       :meeting_date => Date.today + 1.day,
                                       :school_class_id => @pupil.school_class.id )

        click_link 'Родительские собрания'
        click_link "#{@pupil.pupil_last_name} #{@pupil.pupil_first_name} " +
                   "#{@pupil.pupil_middle_name}"
      end

      it "should show fresh meeting" do
        @pupil.school_class.meetings.fresh_meetings.first.should == @meeting
        # response.should have_selector('table', :name => "meetings") do |table|
        #   table.should have_selector('tbody') do |tbody|
        #     tbody.should have_selector('tr') do |td|
        #       td.should contain( @text )
        #     end
        #   end
        # end
      end
    end

    describe "Events" do
      before(:each) do
        @event = FactoryGirl.create( :event,
                                     :event_begin_date => "#{Date.today}",
                                     :event_end_date => "#{Date.today}",
                                     :school_class_id => @pupil.school_class.id )
        click_link 'Мероприятия'
        click_link "#{@pupil.pupil_last_name} #{@pupil.pupil_first_name} " +
                   "#{@pupil.pupil_middle_name}"
      end

      it "should find fresh event" do
        @pupil.school_class.events.fresh_events.first.should == @event
      end
    end

    describe "Journal" do
      before(:each) do
        @curriculum = FactoryGirl.create( :curriculum, :school_class_id => @pupil.school_class.id  )
        click_link 'Успеваемость'
        click_link "#{@pupil.pupil_last_name} #{@pupil.pupil_first_name} " +
                   "#{@pupil.pupil_middle_name}"
        click_link 'Выбрать предмет'
        click_link "#{@curriculum.qualification.subject.subject_name}"
        visit journals_show_parent_path( :p_id => @pupil.id, :curr_id => @curriculum.id )
      end

      it "should have subject name" do
        @pupil.school_class.curriculums.first.qualification.subject.subject_name.should == 'Math'
      end
    end
  end
end
