class TeamsController < ApplicationController
  before_action :set_team, only: %i[ show edit update destroy ]
  before_action :set_buyer

  def index
    @teams = @buyer.teams.order(:name)
  end

  def show
  end

  def new
    @team = Team.new
    respond_to do |format|
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def create
    @team = Team.new(team_params)
    respond_to do |format|
      if @team.save
        format.html { redirect_to @buyer, notice: "Team was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update(team_params)
        format.html { redirect_to @buyer, notice: "Team was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to @buyer, notice: "Team was successfully deleted." }
    end
  end

  private
    def set_team
      @team = Team.find(params[:id])
    end

    def team_params
      params.require(:team).permit(:name, :buyer_id)
    end

    def set_buyer
      @buyer = Buyer.find(params[:buyer_id])
    end
end
