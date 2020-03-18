class RoundsController < ApplicationController
  before_action :user_admin!

  def index
    @rounds = Round.all
  end

  # FIMXE NON RISCRIVERE @ROUND
  def new
    @round = Round.new
  end

  def edit
    @round = Round.find(params[:id])
  end

  def create
    @round = Round.new(round_params)
    if @round.save
      redirect_to rounds_path
    end
  end

  def update
    @round = Round.find(params[:id])
    if @round.update_attributes(round_params)
      redirect_to rounds_path
    end
  end

  private

  def round_params
    params.require(:round).permit(:start_date, :end_date)
  end
end

