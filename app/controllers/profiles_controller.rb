class ProfilesController < ApplicationController
  before_action :user_not_student!
  before_action :get_profile_and_check_permission, only: [:show, :edit, :update, :set_area, :close, :resign] 
  
  def index
    @profiles = current_user.my_profiles(@current_round)
                            .includes(:student)
                            .order('profiles.done asc, users.surname').references(:profiles, :users)
    @profiles = @profiles.where('profiles.id IN (?)', params[:ids]) if params[:ids]

    @missing_punches = Punch.missing.where('profile_id IN (?)', @profiles.ids)
    
    @total_presences = Profile.total_presences
    @present_punches = Punch.includes(:profile).in_today.where('departure IS NULL')
    @present_punches = @present_punches.where('profiles.organization_id = ?', @current_organization).references(:profiles) if @current_organization
  end

  def show
    @punches = @profile.punches.order("COALESCE(punches.arrival, punches.departure) desc")
  end

  def new
  end

  def create
    @profiles = Profile.add_by_employee_ids(params[:mat].split(), params[:organization_id], params[:round_id])
  end

  def edit
    @profile.done and raise "Non attivo"
    @punches = @profile.punches.order(Arel.sql("COALESCE(punches.arrival, punches.departure) desc"))
    @total_presence = @profile.total_presence
    @areas = @current_organization ? @current_organization.areas : Area.all
  end

  def update
    if current_user.owns_profile_as_secretary?(@profile)
      check_area_ids_organization!
      @profile.area_ids      = params[:profile][:area_ids]
      @profile.general_notes = params[:profile][:general_notes]
      @profile.student.update_attribute(:telephone, params[:profile].delete(:telephone))
    elsif current_user.owns_profile_as_supervisor?(@profile)
      @profile.area_notes = params[:profile][:area_notes]
    end

    if @profile.save
      flash[:notice] = current_user.owns_profile_as_secretary?(@profile) ? 
                       "#{@profile.student} assegnato a #{@profile.areas_string}" : "Le note sono state aggiornate."
    else
      raise @profile.errors.inspect
    end
    redirect_to edit_profile_path(@profile)
  end


  # FIXME solo se ha qualche ora fatta
  def close
    @profile.done = 1
    @profile.save!
    redirect_to profiles_path
  end
  
  def resign
    @profile.done = 1
    @profile.resign = 1
    @profile.save!
    redirect_to profiles_path
  end

  private 

  def get_profile_and_check_permission
    @profile = Profile.find(params[:id])
    current_user.owns_profile?(@profile) or raise DmUniboCommon::NoAccess
  end

  # FIMXE move in models
  def check_area_ids_organization!
    current_user.admin? and return true
    Area.where(id: params[:profile][:area_ids])
        .select(:organization_id)
        .pluck(:organization_id).uniq == [@current_organization.id] or raise "NO CORRECT ORGANIZATION"
  end

end

