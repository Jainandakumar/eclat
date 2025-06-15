class MailersController < ApplicationController

  def index
    @mailer = Mailer.new(params)
    return_path, message = @mailer.process_mailer
    respond_to do |format|
      format.html {redirect_to return_path, notice: 'Reminder mail successfully sent.'}
      format.json {render json: {status: 200, notice: 'Reminder mail successfully sent.'}}
    end
  end

  def show
  end

  def new
    @mailer = Mailer.new
  end

  def edit
  end

  def create
    @mailer = Mailer.new(mailer_params)

    if @mailer.save
      redirect_to @mailer, notice: 'Mailer was successfully created.'
    else
      render :new
    end
  end

  def update
    if @mailer.update(mailer_params)
      redirect_to @mailer, notice: 'Mailer was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @mailer.destroy
    redirect_to mailers_url, notice: 'Mailer was successfully destroyed.'
  end

  private

  def set_mailer
    @mailer = Mailer.find(params[:id])
  end

  def mailer_params
    params.require(:mailer).permit(:subject, :body, :recipient_email)
  end
end