# encoding: UTF-8
require 'spec_helper'

describe "Teachers" do
  before(:each) do

    # Here we use trick. First of all we create timetable with teacher first and
    # only then we edit it's user to be correct. I found that only this works.
    timetable = FactoryGirl.create( :timetable )
    @t = timetable.curriculum.qualification.teacher.user
    @t.user_role = "teacher"
    @t.save!

    @subject_name = @t.teacher.subjects.first.subject_name
    @teacher_class = @t.teacher.qualifications.first.curriculums.first.school_class

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

    describe "Lesson" do
      describe "Creating" do
        before(:each) do
          click_link "Журнал"
          click_link @subject_name
        end

        describe "View" do
          it "should have placeholders" do
            click_link "Создать дату"
            click_link @teacher_class.class_code
            visit new_lesson_path( :class_code => @teacher_class.class_code,              # Visit manually because in app we use javascript.
                                   :subject_name => @subject_name )

            response.should have_selector( 'input',
                                           :name => "lesson[lesson_date]",
                                           :placeholder => @everpresent_field_placeholder )
          end
        end

        describe "Create" do
          it "should save new lesson with valid params" do
            expect do
              click_link "Создать дату"
              click_link @teacher_class.class_code
              visit new_lesson_path( :class_code => @teacher_class.class_code,            # Visit manually because in app we use javascript.
                                     :subject_name => @subject_name )

              fill_in "Дата", :with => "#{Date.today}"
              click_button "Создать"
            end.should change( Lesson, :count ).by( 1 )
          end

          it "should not save new lesson with invalid params" do
            expect do
              click_link "Создать дату"
              click_link @teacher_class.class_code
              visit new_lesson_path( :class_code => @teacher_class.class_code,            # Visit manually because in app we use javascript.
                                     :subject_name => @subject_name )

              fill_in "Дата", :with => ""
              click_button "Создать"
            end.should_not change( Lesson, :count )
          end
        end

        describe "Update" do
          before(:each) do
            # Creating lesson.
            visit new_lesson_path( :class_code => @teacher_class.class_code,              # Visit manually because in app we use javascript.
                                   :subject_name => @subject_name )
            fill_in "Дата", :with => "#{Date.today}"
            click_button "Создать"
          end

          it "should update with valid params" do
            click_link "Выбрать класс"
            click_link @teacher_class.class_code
            click_link @t.teacher.qualifications.first.curriculums.first.timetables.first.lessons.first.lesson_date.strftime("%d.%m.%Y")

            fill_in "Дата", :with => "#{Date.today}"

            click_button "Обновить"

            flash[:success].should =~ /Урок успешно обновлен!/i
          end

          it "should not update with invalid params" do
            click_link "Выбрать класс"
            click_link @teacher_class.class_code
            click_link @t.teacher.qualifications.first.curriculums.first.timetables.first.lessons.first.lesson_date.strftime("%d.%m.%Y")

            fill_in "Дата", :with => ""

            click_button "Обновить"

            flash[:error].should_not be_nil
          end
        end
      end
    end
  end
end
