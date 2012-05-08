# encoding: UTF-8
class EventsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :index, :new, :create ]
  
  def index
    @class_code = get_class_code( current_user )
  end
  
  def new
    @class_code = get_class_code( current_user )
    @everpresent_field_placeholder = "Обязательное поле"
    @event = Event.new
    @teachers = collect_teachers
    @choosen_teacher = @teachers.first.last unless @teachers.empty?                       # First - array, then last element in array. So we get first teacher.
  end
  
  def create
    @class_code = get_class_code( current_user )
    @everpresent_field_placeholder = "Обязательное поле"
    @event = Event.new( params[:event] )
    @teachers = collect_teachers   
    @choosen_teacher = @event.teacher.id unless @teachers.empty?
    
    if @event.save
      flash[:success] = "Мероприятие успешно создано!"
      redirect_to events_path 
    else
      flash.now[:error] = @event.errors
                                .full_messages
                                .to_sentence :last_word_connector => ", ",        
                                             :two_words_connector => ", "
      render "new"
    end
  end
  
  private
    def get_class_code( current_user )
      current_user.teacher_leader.school_class.class_code
    end
    
    # Collect array of ["teacher names", teacher.id] which are options of select in view.
    def collect_teachers
      Teacher.all.collect do |t| 
        [ "#{t.teacher_last_name} #{t.teacher_first_name} #{t.teacher_middle_name}", t.id ] 
      end
    end
end
