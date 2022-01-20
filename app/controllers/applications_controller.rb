class ApplicationsController < ApplicationController
  before_action :set_application, only: [:show]

  def index
    @applications = Application.all
    render json: @applications.as_json(only: [:name, :chats_count])
  end

  def show
    render json: @application.as_json(only: [:name, :chats_count])
  end

  def create
    if !Application.new(application_params).valid?
      render json: { result: "Parameters Invalid" }
    end
    generated_token = Application.new_token
    Publisher.publish("applications",{
      name: params[:name],
      token: generated_token,
      method: "create"
    })
    render json: { name: params[:name], token:  generated_token}
  end

  def update
    if params[:application][:name].present? && params[:token].present?
      Publisher.publish("applications",{
        name: params[:application][:name],
        token: params[:token],
        method: "update"
      })
      render json: { result: "Update: Success"}
    else
      render json: { result: "Failed" }
    end
  end

  def destroy
    Publisher.publish("applications",{
      token: params[:token],
      method: "delete"
    })
    render json: { result: "Delete: Success" }
  end

  private
  def set_application
    @application = Application.find_by(token: params[:token])
  end

  def application_params
    params.require(:application).permit(:name)
  end
end
