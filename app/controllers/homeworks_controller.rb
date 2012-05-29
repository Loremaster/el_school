# encoding: UTF-8
class HomeworksController < ApplicationController
  before_filter :authenticate_teachers, :only => [ :index, :new, :create ]

  def index
    @subject = []; @pupils = []; @classes = SchoolClass.all
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
  end

  def new
    @subject = []; @everpresent_field_placeholder = "Обязательное поле"
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @lessons = lessons_for_select_list( current_user.teacher, @subject.subject_name, @school_class )
    @homework = Homework.new
  end

  def create
    @subject = []; @everpresent_field_placeholder = "Обязательное поле"
    @subject, @school_class = extract_class_code_and_subj_name( params, :subject_name, :class_code )
    @lessons = lessons_for_select_list( current_user.teacher, @subject.subject_name, @school_class )
    @homework = Homework.new( params[:homework] )

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

  private
    def lessons_for_select_list( teacher, subject_name, school_class )
      lessons = []; final_lessons = []
      timetables = timetables_for_teacher_with_subject( current_user.teacher, subject_name,
                                                        school_class )
      timetables.each { |t| lessons << t.lessons  }                                       # Collect lessons from timetales.

      unless lessons.empty?
        final_lessons = lessons.flatten.sort_by{ |l| l[:lesson_date] }                      # Sort output lessons by it's date.

        unless final_lessons.empty?
          final_lessons.collect do |l|
            [ "#{l.lesson_date.strftime("%d.%m.%Y")} - #{l.timetable.tt_number_of_lesson}й урок", # Collect array date - number of lesson
              l.id ]
          end
        else
          []                                                                              # => [] if no lessons founded.
        end
      else
        []                                                                                # => [] if no lessons founded.
      end
    end
end
