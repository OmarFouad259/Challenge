class ChatsWorker
  include Sneakers::Worker
  from_queue "chats", env: nil

  def work(raw_post)
    ActiveRecord::Base.connection_pool.with_connection do
      chat_json = JSON.parse(raw_post)
      method = chat_json["method"]
      chat_json.delete("method")
      app_id = get_app_id chat_json["app_token"]
      chat_json.delete("app_token")
      chat_attr = {
        number: chat_json["number"],
        application_id: app_id
      }
      if method == "create"
        chat = Chat.create!(chat_attr)
      elsif method == "delete"
        Chat.find_by(chat_attr).destroy
      end
    end
    ack!
  end

  def get_app_id(token)
    Application.find_by(token: token).id
  end
end