class Publisher
  def self.publish(channel_name ,message = {})
    @@connection = $bunny.tap do |c|
      c.start
    end
    @@channel = @@connection.create_channel
    @@fanout = @@channel.fanout(channel_name)
    @@queue = @@channel.queue(channel_name, durable: true).tap do |q|
      q.bind(channel_name)
    end
    @@fanout.publish(message.to_json)
  end
end