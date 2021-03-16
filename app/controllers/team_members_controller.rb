class TeamMembersController < ApplicationController
  before_action :set_team_member, only: %i[ show edit update destroy ]
  before_action :set_buyer_and_team

  def index
    @team_members = TeamMember.all
  end

  def show
  end

  def new
    @team_member = TeamMember.new
    respond_to do |format|
      format.js {render file: "team_members/form.js.erb"}
    end
  end

  def edit
    respond_to do |format|
      format.js {render file: "team_members/form.js.erb"}
    end
  end

  def create
    @team_member = TeamMember.new(team_member_params)
    respond_to do |format|
      if @team_member.save
        format.html { redirect_to @buyer, notice: "Team member was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @team_member.update(team_member_params)
        format.html { redirect_to @buyer, notice: "Team member was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @team_member.destroy
    respond_to do |format|
      format.html { redirect_to @buyer, notice: "Team member was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    def set_team_member
      @team_member = TeamMember.find(params[:id])
    end

    def team_member_params
      params.require(:team_member).permit(:name, :email, :phone, :team_id)
    end

    def set_buyer_and_team
      @buyer = Buyer.find(params[:buyer_id])
      @team = Team.find(params[:team_id])
    end
end
