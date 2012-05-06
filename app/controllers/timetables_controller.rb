# encoding: UTF-8
class TimetablesController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]

  def index
    @classes = SchoolClass.order( :class_code ) 
    @tts = []
    
    if params.has_key?( :class_code )
      school_class = SchoolClass.where( "class_code = ?", params[:class_code] ).first 
      @tts = timetable_for_class( school_class )
      @tt_monday = @tts.select{|t| t.tt_day_of_week == "Mon"}                             # Timetable for monday.
      @tt_tuesday = @tts.select{|t| t.tt_day_of_week == "Tue"}                            # Timetable for tuesday.
      
      # flash[:notice] = "#{@tts}"
    end
  end
  
  def new
    if ( params.has_key?( :class_code ) )                                                 # If it's first time (no errors appeared)
      @class = SchoolClass.where( "class_code = ?", params[:class_code] ).first
      $global_class = @class                                                              # Here we global var because after redirect we loose our school class.
    else
      @class = $global_class  
    end
    
    @tt = Timetable.new   
    @subjects = collect_subjects_with_curriculums( @class )
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
  
  private
    
    # Collecting subjects names for school class and curriculum_id for each subject.   
    def collect_subjects_with_curriculums( school_class )
      subjects = school_class.curriculums.collect do |c| 
        [ c.qualification.subject.subject_name, c.id  ] 
      end          
    end
    
    def timetable_for_class( school_class )
      timetable = []
      school_class.curriculums.each { |c| c.timetables.each{ |t| timetable << t } }
      timetable
    end
    
    def subjects_of_class( school_class )
      subjects = school_class.curriculums.collect do |c| 
        c.qualification.subject.subject_name 
      end
    end
end
