class RoundsController < ApplicationController
  before_action :get_round_and_check_permission, only: [:edit, :update]  

  def index
    @rounds = Round.all
    authorize :round
  end

  # FIMXE NON RISCRIVERE @ROUND
  def new
    @round = Round.new
    authorize @round
  end

  def create
    @round = Round.new(round_params)
    authorize @round
    if @round.save
      redirect_to rounds_path
    end
  end

  def edit
  end

  def update
    if @round.update_attributes(round_params)
      redirect_to rounds_path
    end
  end

  private

  def get_round_and_check_permission
    @round = Round.find(params[:id])
    authorize(@round)
  end

  def round_params
    params.require(:round).permit(:start_date, :end_date)
  end
end

