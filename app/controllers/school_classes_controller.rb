# encoding: UTF-8
class SchoolClassesController < ApplicationController
  before_filter :authenticate_school_heads, :only => [ :index, :new, :create, :edit, :update ]
  
  def index
    @class_exist = SchoolClass.first ? true : false
    @teachers_leaders_exist = TeacherLeader.first ? true : false
    @teachers_exist = Teacher.first ? true : false
    @classes = SchoolClass.order('class_code')
  end
  
  def new
    @everpresent_field_placeholder = "Обязательное поле"
    @leaders = collect_teachers_leaders 
    @choosen_teacher = @leaders.first.last unless @leaders.empty?                         # First - array, then last element in array. So we get first teacher.    
    @class = SchoolClass.new 
    @pupils = Pupil.order('pupil_last_name, pupil_first_name, pupil_middle_name') 
  end
  
  def create
    @everpresent_field_placeholder = "Обязательное поле"
    @class = SchoolClass.new( params[:school_class] )
    @leaders = collect_teachers_leaders
    @choosen_teacher = @class.teacher_leader.id unless @class.nil?
    
    if @class.save
      redirect_to school_classes_path
      flash[:success] = "Класс успешно создан!"
    else
      flash[:error] = @class.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                              :two_words_connector => ", "
      render 'new'
    end    
  end
  
  def edit
    @class = SchoolClass.find( params[:id] )
    @leaders = collect_teachers_leaders
    @choosen_teacher = @class.teacher_leader.id unless @class.nil? 
    @everpresent_field_placeholder = "Обязательное поле"
    @pupils = Pupil.order('pupil_last_name, pupil_first_name, pupil_middle_name') 
    @teachers = Teacher.all
  end
  
  def update
    @class = SchoolClass.find( params[:id] )
    @leaders = collect_teachers_leaders  
    @choosen_teacher = params[:school_class][:teacher_leader_id] 
    @everpresent_field_placeholder = "Обязательное поле"
      
    if @class.update_attributes( params[:school_class] )      
      redirect_to school_classes_path
      flash[:success] = "Класс успешно обновлен!"
    else
      flash[:error] = @class.errors.full_messages.to_sentence :last_word_connector => ", ",        
                                                              :two_words_connector => ", "
      render "edit"
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
