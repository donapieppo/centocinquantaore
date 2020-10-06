class PunchesController < ApplicationController
  #
  #
  # before_action :user_student!, only: [:index, :in, :out]
  #
  #
  #
  before_action :get_profile, only: [:new, :create]
  before_action :get_punch_and_check_permission, only: [:edit, :update, :edit_missing, :missing, :destroy]

  def index
    @profile = current_user.active_profile
    # puo' non avere un profilo in questo round
    @punches = @profile ? @profile.punches.order('arrival desc').load : []
    authorize :punch
  end

  def in
    authorize :punch
    flash[:notice] = "NON HAI MARCATO USCITA PRECEDENTE." if current_user.present_now?
    current_user.enter_now(request.remote_ip)
    redirect_to punches_path, notice: "Hai marcato l'ingresso."
  end

  def out
    authorize :punch
    flash[:notice] = "NON HAI MARCATO ENTRATA." unless current_user.present_now?
    current_user.depart_now(request.remote_ip)
    redirect_to punches_path, notice: "Hai marcato l'uscita."
  end

  def new
    @punch = @profile.punches.build
    @punch.arrival = @punch.departure = Time.now.beginning_of_hour
    authorize @punch
  end

  # "punch"=>{"arrival"=>"22/06/2015", "arrival_hour"=>"13", "arrival_minute"=>"54", "departure_hour"=>"13", "departure_minute"=>"54"}
  def create
    @punch = @profile.punches.new
    p = params[:punch]
    @punch.arrival   = p[:arrival] + " " + p[:arrival_hour]   + ":" + p[:arrival_minute]
    @punch.departure = p[:arrival] + " " + p[:departure_hour] + ":" + p[:departure_minute]
    authorize @punch
    if @punch.save 
      redirect_to profiles_path, notice: "Inserite timbrature di #{@profile.student}."
    else
      # @punch.errors[:base] << @punch.errors[:arrival] + @punch.errors[:departure]
      render action: 'new'
    end
  end

  def edit
    @punch.arrival   ||= @punch.day
    @punch.departure ||= @punch.day
  end

  def update
    p = params[:punch]
    @punch.arrival   = p[:arrival] + " " + p[:arrival_hour]   + ":" + p[:arrival_minute]
    @punch.departure = p[:arrival] + " " + p[:departure_hour] + ":" + p[:departure_minute]
    if @punch.save
      redirect_to profiles_path, notice: "Aggiornate timbrature di #{@punch.profile.student}."
    else
      redirect_to edit_profile_path(@punch.profile), alert: @punch.flash_error
    end
  end

  def edit_missing
    @punch.arrival and @punch.departure and raise "Nulla da inserire"
  end

  def missing
    @punch.arrival and @punch.departure and raise "Nulla da inserire"
    datetime = @punch.day.change(hour: params[:hour].to_i, min: params[:min].to_i)
    if @punch.arrival
      @punch.departure = datetime
    else
      @punch.arrival = datetime
    end
    if @punch.save
      redirect_to profiles_path, notice: "La marcatura è stata inserita."
    else
      render action: 'edit_missing'
    end
  end
  
  def destroy
    @punch.destroy 
    redirect_to edit_profile_path(@punch.profile)
  end

  private 

  def get_profile
    @profile = Profile.find(params[:profile_id])
  end

  def get_punch_and_check_permission
    @punch = Punch.includes(:profile).find(params[:id])
    authorize @punch
  end

end

