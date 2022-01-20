class ApplicationsWorker
  include Sneakers::Worker
  from_queue "applications", env: nil

  def work(raw_post)
    ActiveRecord::Base.connection_pool.with_connection do
      app_json = JSON.parse(raw_post)
      method = app_json["method"]
      app_json.delete("method")
      if method == "create"
        app = Application.create!(app_json)
      elsif method == "update"
        @application = Application.find_by(token: app_json["token"])
        @application.update_attributes(:name => app_json["name"])
      elsif method == "delete"
        Application.find_by(token: app_json["token"]).destroy
      end
    end
    ack!
  end
end