class MessagesController < ApplicationController
  before_action :set_app, only: [:index, :show]
  before_action :set_chat, only: [:index, :show]
  before_action :set_message, only: [:show]

  def index
    @messages = @chat.messages.all
    render json: @messages.as_json(only: [:number, :content])
  end

  def show
    render json: @message.as_json(only: [:number, :content])
  end


  def create
    if params[:message][:content].present? && params[:application_token].present? && params[:chat_number].present?
      msg_no = get_message_number(params[:application_token], params[:chat_number])
      Publisher.publish("messages",{
        content: params[:message][:content],
        app_token: params[:application_token],
        chat_number: params[:chat_number],
        number: msg_no,
        method: "create"
      })
      render json: { result: "Create: Success", message_number: msg_no}
    else
      render json: { result: "Failed" }
    end
  end


  def update
    if params[:message][:content].present? && params[:application_token].present? && params[:chat_number].present?
      Publisher.publish("messages",{
        content: params[:message][:content],
        app_token: params[:application_token],
        chat_number: params[:chat_number],
        number: params[:number],
        method: "update"
      })
      render json: { result: "Update: Success"}
    else
      render json: { result: "Failed" }
    end
  end


  def destroy
    if params[:message][:content].present? && params[:application_token].present? && params[:chat_number].present?
      Publisher.publish("messages",{
        app_token: params[:application_token],
        chat_number: params[:chat_number],
        number: params[:number],
        method: "delete"
      })
      render json: { result: "Delete: Success"}
    else
      render json: { result: "Failed" }
    end
  end

  private
  def set_message
    @message = Message.find_by(number: params[:number])
    render json: { result: "Failed" } unless @message
  end

  def set_chat
    @chat = @app.chats.find_by(number: params[:chat_number])
    render json: { result: "Failed" } unless @chat
  end

  def set_app
    @app = Application.find_by(token: params[:application_token])
    render json: { result: "Failed" } unless @app
  end

  def get_message_number(app_token, chat_number)
    $redis.incr("message_counter#{app_token}-#{chat_number}")
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
