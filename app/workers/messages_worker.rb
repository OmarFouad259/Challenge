class MessagesWorker
  include Sneakers::Worker
  from_queue "messages", env: nil

  def work(raw_post)
    ActiveRecord::Base.connection_pool.with_connection do
      msg_json = JSON.parse(raw_post)
      method = msg_json["method"]
      chat_id = get_chat_id msg_json["app_token"], msg_json["chat_number"]
      msg_attr = {
        content: msg_json["content"],
        number: msg_json["number"],
        chat_id: chat_id
      }
      if method == "create"
        Message.create!(msg_attr)
      elsif method == "delete"
        Message.find_by(chat_id: chat_id, number: msg_json["number"]).destroy
      elsif method == "update"
        Message.find_by(chat_id: chat_id, number: msg_json["number"]).update(msg_attr)
      end
      puts msg_json
      puts method
    end
    ack!
  end

  def get_chat_id(token, number)
    Application.find_by(token: token).chats.find_by(number: number).id
  end

end