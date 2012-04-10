# encoding: UTF-8
class SchoolClassesController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create ]
  
  def index
    @class_exist = SchoolClass.first ? true : false
    @teachers_leaders_exist = TeacherLeader.first ? true : false
    @teachers_exist = Teacher.first ? true : false
    @classes = SchoolClass.all 
  end
  
  def new
    @everpresent_field_placeholder, @class_code = "Обязательное поле", ""
    @creation_class_date = ""
    @leaders = collect_teachers_leaders 
    @choosen_teacher = @leaders.first.last unless @leaders.empty?                         # First - array, then last element in array. Get it ONLY if we've found data.    
    @class = SchoolClass.new 
    
    if params.has_key?( :school_class )
      @class_code = params[:school_class][:class_code]
      @creation_class_date = params[:school_class][:date_of_class_creation]
      @choosen_teacher = params[:school_class][:teacher_leader_id]
    end  
  end
  
  def create
    school_class = SchoolClass.new( params[:school_class] )
    if school_class.save
      flash[:success] = "Класс успешно создан!"
      redirect_to school_classes_path
    else
      flash[:error] = school_class.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                                    :two_words_connector => ", "
      redirect_to new_school_class_path( params )
    end    
  end
  
  private   
    # Collect array of ["teacher names", teacher.id] which are options of select in view.
    def collect_teachers_leaders
      TeacherLeader.all.collect do |t| 
       [ "#{t.teacher.teacher_last_name} #{t.teacher.teacher_first_name} #{t.teacher.teacher_middle_name}", t.id ] 
      end
    end
end