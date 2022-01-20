class ChatsController < ApplicationController
  before_action :set_app, only: [:index, :show]
  before_action :set_chat, only: [:show]

  def index
    @chats = @app.chats
    render json: @chats.as_json(only: [:number, :messages_count])
  end

  def show
    render json: @chat.as_json(only: [:number, :messages_count])
  end

  def create
    new_number = get_chat_number(params[:application_token])
    Publisher.publish("chats",{
      number: new_number,
      app_token: params[:application_token],
      method: "create"
    })
    render json: { result: "success", number: new_number}
  end

  def destroy
    Publisher.publish("chats",{
      number: params[:number],
      app_token: params[:application_token],
      method: "delete"
    })
    render json: { result: "success"}
  end

  private
  def set_chat
    @chat = @app.chats.find_by(number: params[:number])
    render json: @chat.errors, status: :unprocessable_entity unless @chat
  end

  def get_chat_number(app_token)
    $redis.incr("chat_counter-#{app_token}")
  end

  def set_app
    @app = Application.find_by(token: params[:application_token])
    render json: @app.errors, status: :unprocessable_entity unless @app
  end
end
