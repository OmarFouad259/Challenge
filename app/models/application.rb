class Application < ApplicationRecord
  has_many :chats, dependent: :destroy
  validates :name,  presence: true, length: { maximum: 50 }
  attr_accessor :app_token
  validates :token,  uniqueness: true

  after_find do
    self.cached_chats_count
  end


  class << self
    def new_token
      SecureRandom.urlsafe_base64
    end
  end


  def cached_chats_count
    if($redis.get("#{self.token}-CHATS_COUNT"))
      $redis.get("#{self.token}-CHATS_COUNT")
    else
      chats_count = self.chats.count
      $redis.set("#{self.token}-CHATS_COUNT",chats_count, ex: 3600)
      self.chats_count = chats_count
      self.save!
      chats_count
    end
  end
end
