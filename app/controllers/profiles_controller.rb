class ProfilesController < ApplicationController
  before_action :get_profile_and_check_permission, only: [:show, :edit, :update, :set_area, :close, :resign] 

  def index
    authorize current_organization, :list_profiles?
    @profiles = current_organization.profiles.includes(:student,:areas)
      .where(round: @current_round)
      .order('profiles.done asc, users.surname')
      .references(:profiles, :users)
    if ! policy(current_organization).manage?
      @profiles = @profiles.where('profiles.id in (?)', current_user.profiles_as_supervisor_ids)
    end

    @profiles = @profiles.where('profiles.id IN (?)', params[:ids]) if params[:ids]

    @missing_punches = Punch.missing.where('profile_id IN (?)', @profiles.ids)

    @total_presences = Profile.total_presences
    @present_punches = Punch.includes(:profile).in_today
      .where('departure IS NULL')
      .where('profiles.organization_id = ?', current_organization)
      .references(:profiles)
  end

  def show
    @punches = @profile.punches.order("COALESCE(punches.arrival, punches.departure) desc")
  end

  # FIXME
  def new
    authorize :profile
  end

  # FIXME
  def create
    authorize :profile
    @profiles = Profile.add_by_employee_ids(params[:mat].split(), params[:organization_id], params[:round_id])
  end

  def edit
    @profile.done and raise "Non attivo"
    @punches = @profile.punches.order(Arel.sql("COALESCE(punches.arrival, punches.departure) desc"))
    @total_presence = @profile.total_presence
    @areas = current_organization.areas 
  end

  def update
    if policy(@profile).update_all_fields?
      check_area_ids_organization!
      @profile.area_ids      = params[:profile][:area_ids]
      @profile.general_notes = params[:profile][:general_notes]
      @profile.student.update_attribute(:telephone, params[:profile].delete(:telephone))
    elsif policy(@profile).update_notes?
      @profile.area_notes = params[:profile][:area_notes]
    end

    if @profile.save
      flash[:notice] = "Il profilo è stato aggiornato correttamente."
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
    authorize(@profile)
  end

  # FIMXE move in models
  def check_area_ids_organization!
    # params[:profile][:area_ids] can be [""] with hidden default 
    if params[:profile][:area_ids] != [""]
      Area.where(id: params[:profile][:area_ids])
          .pluck(:organization_id).uniq == [current_organization.id] or raise "NO CORRECT ORGANIZATION"
    end
  end

end

