# encoding: UTF-8
class TimetablesController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create, :edit, 
                                                       :update ]

  def index
    @classes = SchoolClass.order( :class_code )                                           # List of classes, use this in buttons to create/filter.
    @tts = []; @class_code = nil
    
    if params.has_key?( :class_code )
      school_class = SchoolClass.where( "class_code = ?", params[:class_code] ).first 
      @class_code = school_class.class_code
      tts = timetable_for_class( school_class )                                           # Here we get timetable for class only if subject has been choosed.
      @tt_monday = sorted_timetable_for_day( tts, "Mon" )                                 # Timetable for monday.
      @tt_tuesday = sorted_timetable_for_day( tts, "Tue" )                                # Timetable for tuesday.
      @tt_wednesday = sorted_timetable_for_day( tts, "Wed" )                              # Timetable for wednesday.      
      @tt_thursday = sorted_timetable_for_day( tts, "Thu")                                # Timetable for thursday.
      @tt_friday = sorted_timetable_for_day( tts, "Fri")                                  # Timetable for friday.
    end
  end
  
  def new
    @types_of_lesson = collect_types_of_lesson 
    
    if ( params.has_key?( :class_code ) )                                                 # If you pushed button to create class and you choosed class.
      @class = SchoolClass.where( "class_code = ?", params[:class_code] ).first
      $global_class = @class                                                              # Here we use global var because after redirect we loose our school class.
    else
      @class = $global_class  
    end
    
    # Check if timetable for this class already has been created and then redirect or
    # allowing to create it.
    unless timetable_exists?( $global_class )
      @tt = Timetable.new   
      @subjects = collect_subjects_with_curriculums( @class )
    else
      flash[:notice] = "Расписание для класса #{$global_class.class_code} уже было " +
                       "создано! Пожалуйста, редактируйте уже имеющееся расписание!"
      redirect_to timetables_path( :class_code => $global_class.class_code )              # Show created timetable for class.  
    end    
  end
  
  def create
    errors_messages = []  
    
    # Take, validate and save/or collect errors for user's timetable.
    params[:timetable].each do |i, values|                                                # Where i is the i-th set and values are the user inputs.
      @tt = Timetable.new( values )
      
      if not @tt.save        
        errors_messages << @tt.errors.full_messages.to_sentence   
      end
    end
    
    if errors_messages.empty?
      flash[:success] = "Расписание успешно создано!"
      redirect_to timetables_path
    else
      flash[:error] = errors_messages.to_sentence :last_word_connector => ", ",        
                                                  :two_words_connector => ", "
      redirect_to new_timetable_path
    end   
  end
  
  def edit
    @types_of_lesson = collect_types_of_lesson    
    @tt = Timetable.find( params[:id] ) 
    @subjects_with_curriculums = collect_subjects_with_curriculums( @tt.school_class ) 
  end
  
  def update
    @tt = Timetable.find( params[:id] )
    
    if @tt.update_attributes( params[:timetable] )
      flash[:success] = "Расписание успешно обновлено!"
      redirect_to timetables_path
    else
      flash.now[:error] = @tt.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                               :two_words_connector => ", "
      render 'edit'
    end
  end
  
  private    
    # Collecting subjects names for school class and curriculum_id for each subject.   
    def collect_subjects_with_curriculums( school_class )
      subjects = school_class.curriculums.collect do |c| 
        [ c.qualification.subject.subject_name, c.id  ] 
      end          
    end
    
    # Return for school class it's timetable.
    def timetable_for_class( school_class )
      Timetable.select{|t| t.school_class.class_code == school_class.class_code }.to_a
    end
    
    def subjects_of_class( school_class )
      subjects = school_class.curriculums.collect do |c| 
        c.qualification.subject.subject_name 
      end
    end
    
    # Return sorted by number of lesson tometable for one day.
    def sorted_timetable_for_day( timetable, day )
      timetable.select{ |t| t.tt_day_of_week == day }
               .sort_by{ |e| e[:tt_number_of_lesson] }
    end
    
    # Return russian name for type of lesson.
    def collect_types_of_lesson
      [ ["Обязательное занятие", "Primary lesson"], ["Электив", "Extra"] ]
    end
    
    # Check if timetable already has been created for school class.
    def timetable_exists?( school_class )
      not timetable_for_class( school_class ).empty?
    end
end
