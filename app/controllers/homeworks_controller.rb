# encoding: UTF-8
class HomeworksController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index, :new, :create, :edit, :update ]

  def index
    @subject = []; @pupils = []; @classes = SchoolClass.all; @homeworks_exist = false
    @show_homeworks = false
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )

    if params.has_key?( :subject_name )
      if current_user.teacher.subject_ids.include?( @subject.id )                         # If teacher teach that subject...
        @show_homeworks = true                                                            # ...show homeworks.

        unless @school_class.nil?                                                         # Because we have situation when school_class is not choosen.
          @homeworks_collection = Homework.where( "school_class_id = ?", @school_class.id )
          @homeworks_exist = @homeworks_collection.first ? true : false
        end
      end
    end
  end

  def new
    @subject = []; @everpresent_field_placeholder = "Обязательное поле"
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @lessons = lessons_for_select_list( current_user.teacher, @subject.subject_name, @school_class )
    @homework = Homework.new
    @choosen_lesson = nil
  end

  def create
    @subject = []; @everpresent_field_placeholder = "Обязательное поле"
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @lessons = lessons_for_select_list( current_user.teacher, @subject.subject_name, @school_class )
    @homework = Homework.new( params[:homework] )
    @choosen_lesson = params[:homework][:lesson_id]                                       # To set correct lesson in list.

    if @homework.save
      redirect_to homeworks_path( :class_code => params[:class_code],
	                               :subject_name => params[:subject_name] )
      flash[:success] = "Задание успешно создано!"
    else
      flash.now[:error] = @homework.errors.full_messages
                                   .to_sentence :last_word_connector => ", ",
                                                :two_words_connector => ", "
      render 'new'
    end
  end

  def edit
    @subject = []; @everpresent_field_placeholder = "Обязательное поле"
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @lessons = lessons_for_select_list( current_user.teacher, @subject.subject_name, @school_class )
    @homework = Homework.find( params[:id] )
    @choosen_lesson = @homework.lesson.id                                                 # To set correct lesson in list from database.
  end

  def update
    @subject = []; @everpresent_field_placeholder = "Обязательное поле"
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @lessons = lessons_for_select_list( current_user.teacher, @subject.subject_name, @school_class )
    @homework = Homework.find( params[:id] )
    @choosen_lesson = params[:homework][:lesson_id]                                       # To set correct lesson in list.

    if @homework.update_attributes( params[:homework] )
      redirect_to homeworks_path( :class_code => params[:class_code],
	                                :subject_name => params[:subject_name] )
      flash[:success] = "Задание успешно обновлено!"
    else
      flash.now[:error] = @homework.errors.full_messages
                                   .to_sentence :last_word_connector => ", ",
                                                :two_words_connector => ", "
      render 'edit'
    end
  end

  private
    def lessons_for_select_list( teacher, subject_name, school_class )
      lessons = []; final_lessons = []
      timetables = timetables_for_teacher_with_subject( current_user.teacher, subject_name,
                                                        school_class )
      timetables.each { |t| lessons << t.lessons  }                                       # Collect lessons from timetales to work with them.

      unless lessons.empty?
        final_lessons = lessons.flatten.sort_by{ |l| l[:lesson_date] }                    # Sort output lessons by it's date.

        unless final_lessons.empty?
          final_lessons.collect do |l|                                                    # Collect array date - day - number of lesson - lesson id
            [ "#{l.lesson_date.strftime("%d.%m.%Y")} - " +
              "#{translate_day_of_week(l.timetable.tt_day_of_week)} - " +
              "#{l.timetable.tt_number_of_lesson}й урок",
              l.id ]
          end
        else
          []                                                                              # => [] if no lessons founded (we don't want errors!).
        end
      else
        []                                                                                # => [] if no lessons founded (we don't want errors!).
      end
    end
end
