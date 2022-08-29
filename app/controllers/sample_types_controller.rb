class SampleTypesController < ApplicationController
  before_action :set_sample_type, only: %i[ show edit update destroy ]

  def index
    @sample_types = SampleType.order(:name)
    respond_to do |format|
      format.js {render file: "sample_types/index.js.erb"}
      format.html { }
    end
  end

  def new
    @sample_type = SampleType.new
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
    @sample_type = SampleType.new(sample_type_params)
    respond_to do |format|
      if @sample_type.save
        format.html { redirect_to sample_types_path, notice: "Sample type was successfully created." }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.js 
      end
    end
  end

  def update
    respond_to do |format|
      if @sample_type.update(sample_type_params)
        format.html { redirect_to sample_types_path, notice: "Sample type was successfully updated." }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.js
      end
    end
  end

  def destroy
    @sample_type.destroy
    respond_to do |format|
      format.html { redirect_to sample_types_url, notice: "Sample type was successfully destroyed." }
    end
  end

  private
  
    def set_sample_type
      @sample_type = SampleType.find(params[:id])
    end

    def sample_type_params
      params.require(:sample_type).permit(:name)
    end
end