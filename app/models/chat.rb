class Chat < ApplicationRecord
  has_many :messages, dependent: :destroy
  belongs_to :application

  after_find do
    self.cached_messages_count
  end

  def cached_messages_count
    if($redis.get("#{self.application.token}-#{self.number}-MSGS_COUNT"))
      $redis.get("#{self.application.token}-#{self.number}-MSGS_COUNT")
    else
      msg_count = self.messages.count
      $redis.set("#{self.application.token}-#{self.number}-MSGS_COUNT",msg_count, ex: 3600)
      self.messages_count = msg_count
      self.save!
      msg_count
    end
  end
end
