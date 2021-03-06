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

        click_link 'Расписание'

        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Расписание')
        end

        click_link 'Родительские собрания'

        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Родительские собрания')
        end

        click_link 'Мероприятия'

        response.should be_success
        response.body.should have_selector( "li.active") do
          have_selector('a', :content => 'Мероприятия')
        end
      end
    end

    describe "Journal" do
      before(:each) do
        @estimation = FactoryGirl.create(:estimation, :pupil_id => @pupil.pupil.id)        # Save for pupil estimation
        @estimation.reporting.lesson.timetable.curriculum.school_class = @pupil.pupil.school_class # Save pupil's class for estimation.
        @estimation.reporting.lesson.timetable.curriculum.school_class.save!

        @pupil.pupil.school_class.curriculums << @estimation.reporting.lesson.timetable.curriculum  # Add curriculum to school_class curriculums
        @pupil.pupil.school_class.curriculums.first.save!                                 # And save it.

        click_link 'Успеваемость'
        click_link 'Выбрать предмет'
        click_link "#{@estimation.reporting.lesson.timetable.curriculum.qualification.subject.subject_name}" # Choose subject.
      end

      it "should show journal for pupil" do
        response.should have_selector('table', :name => "journals") do |table|
          table.should have_selector('tbody') do |tbody|
            tbody.should have_selector('td') do |td|
              td.should contain( "#{@estimation.nominal}" )
            end
          end
        end
      end
    end

    # describe "Timetable" do
    #      before(:each) do
    #        @timetable = FactoryGirl.create(:timetable)
    #        @timetable.curriculum.school_class = @pupil.pupil.school_class
    #        @timetable.curriculum.school_class.save!
    #
    #        @pupil.pupil.school_class.curriculums << @timetable.curriculum
    #        @pupil.pupil.school_class.curriculums.first.save!
    #
    #        @timetable.school_class = @pupil.pupil.school_class
    #        @timetable.school_class.save!
    #
    #        click_link 'Расписание'
    #      end
    #
    #      it "should show timetable for pupil" do
    #        puts response.body
    #
    #        response.should have_selector('table', :name => "timetable") do |table|
    #          table.should have_selector('tbody') do |tbody|
    #            tbody.should have_selector('tr') do |tr|
    #              tr.should have_selector('td') do |td|
    #                td.should contain( "#{@timetable.tt_number_of_lesson}" )
    #                td.should contain( "#{@timetable.tt_room}" )
    #              end
    #            end
    #          end
    #        end
    #      end
    #    end

    describe "Meetings" do
      before(:each) do
        @meeting = FactoryGirl.create( :meeting,
                                       :meeting_date => "#{Date.today + 1.day}",
                                       :school_class_id => @pupil.pupil.school_class.id )
        click_link 'Родительские собрания'
      end

      it "should show fresh parents meetings" do
        response.should have_selector('table', :name => "meetings") do |table|
          table.should have_selector('tbody') do |tbody|
            tbody.should have_selector('tr') do |tr|
              tr.should have_selector('td') do |td|
                td.should contain( "#{@meeting.meeting_theme}" )
                td.should contain( "#{@meeting.meeting_room}" )
              end
            end
          end
        end
      end
    end

    describe "Events" do
      before(:each) do
        @event = FactoryGirl.create(:event, :school_class_id => @pupil.pupil.school_class.id)
      end

      it "should save new chosen event" do
        click_link 'Мероприятия'

        expect do
          check "pupil[event_ids][]"
          click_button 'Принять участие'
        end.should change( PupilsEvent, :count ).by( 1 )
      end

      it "should show information about event" do
        visit events_info_pupil_path( :id => @event )

        response.should have_selector('blockquote') do |blk|
          blk.should have_selector('p') do |p|
            p.should contain( "#{@event.teacher.teacher_last_name}"+
                              " #{@event.teacher.teacher_first_name}"+
                              " #{@event.teacher.teacher_middle_name}" )
          end

          blk.should have_selector('small') do |small|
            small.should contain( "Ответственный учитель" )
          end
        end
      end
    end
  end
end
