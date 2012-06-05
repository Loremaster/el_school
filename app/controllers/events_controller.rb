# encoding: UTF-8
class EventsController < ApplicationController
  before_filter :authenticate_class_heads, :only => [ :index, :new, :create, :edit,
                                                      :update ]

  before_filter :authenticate_school_heads, :only => [ :index_school_head ]
  before_filter :authenticate_parents, :only => [ :index_for_parent ]
  before_filter :authenticate_pupils, :only => [ :edit_event_by_pupil,
                                                 :update_event_by_pupil,
                                                 :event_info_for_pupil ]

  def index_school_head
    @classes = SchoolClass.order( :class_code )

    if params.has_key?( :class_code )
      school_class = SchoolClass.where( "class_code = ?", params[:class_code] ).first
      @class_code = school_class.class_code
      @events = events_for( @class_code )
      @event_exist = @events.first ? true : false
    end
  end

  def index_for_parent
     @pupil = nil; @event_exist = false

     if params.has_key?( :p_id )                                                          # If it's pupil id.
       @pupil = Pupil.where( "id = ?", params[:p_id] ).first

       if current_user.parent.pupil_ids.include? @pupil.id                                 # If chosen pupil is child of parent.
         @fresh_events = @pupil.school_class.events.fresh_events
         @event_exist = @fresh_events.first ? true : false
       end
     end
  end

  def edit_event_by_pupil
    @school_class = current_user.pupil.school_class; @pupil_events_exist = false
    @pupil = current_user.pupil

    unless @school_class.nil?
      @pupil_events = events_for( @school_class.class_code )
      @pupil_events_exist = @pupil_events.first ? true : false
    end
  end

  def update_event_by_pupil
    @school_class = current_user.pupil.school_class; @pupil_events_exist = false
    @pupil = current_user.pupil

    unless @school_class.nil?
      @pupil_events = events_for( @school_class.class_code )
      @pupil_events_exist = @pupil_events.first ? true : false

      if @pupil.update_attributes(params[:pupil])
        redirect_to events_edit_pupil_path
        flash[:success] = "Ваше участие принято!"
      else
        flash.now[:error] = @pupil.errors.full_messages
                                          .to_sentence :last_word_connector => ", ",
                                                       :two_words_connector => ", "
        render "edit_event_by_pupil"
      end
    end
  end

  def event_info_for_pupil
    @event = Event.find( params[:id] )
    @school_class = current_user.pupil.school_class

    unless @school_class.nil?
      @pupils_on_event = @event.pupils
    end
  end

  def index
    school_class = get_class( current_user )
    @class_code = school_class.class_code
    @event_exist = Event.first ? true : false
    @events = events_for( @class_code )
  end

  def new
    @school_class = get_class( current_user )
    @class_code = @school_class.class_code
    @everpresent_field_placeholder = "Обязательное поле"
    @event = Event.new
    @teachers = collect_teachers
    @choosen_teacher = @teachers.first.last unless @teachers.empty?                       # First - array, then last element in array. So we get first teacher.
  end

  def create
    @school_class = get_class( current_user )
    @class_code = @school_class.class_code
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

  def edit
    @school_class = get_class( current_user )
    @class_code = @school_class.class_code
    @everpresent_field_placeholder = "Обязательное поле"
    @event = Event.find( params[:id] )
    @teachers = collect_teachers
    @choosen_teacher = @event.teacher.id unless @teachers.empty?
  end

  def update
    @school_class = get_class( current_user )
    @class_code = @school_class.class_code
    @everpresent_field_placeholder = "Обязательное поле"
    @event = Event.find( params[:id] )
    @teachers = collect_teachers
    @choosen_teacher = @event.teacher.id unless @teachers.empty?

    if @event.update_attributes( params[:event] )
      flash[:success] = "Мероприятие успешно обновлено!"
      redirect_to events_path
    else
      flash.now[:error] = @event.errors
                                .full_messages
                                .to_sentence :last_word_connector => ", ",
                                             :two_words_connector => ", "
      render "edit"
    end
  end

  private
    # Collect array of ["teacher names", teacher.id] which are options of select in view.
    def collect_teachers
      Teacher.all.collect do |t|
        [ "#{t.teacher_last_name} #{t.teacher_first_name} #{t.teacher_middle_name}", t.id ]
      end
    end

    # Get events for school class via class code.
    def events_for( class_code )
      Event.select{|e| e.school_class.class_code == class_code }
           .sort_by{ |e| e[:event_begin_date] }
           .sort_by{ |e| e[:event_begin_time] }
    end
end
