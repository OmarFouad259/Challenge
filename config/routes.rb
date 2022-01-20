Rails.application.routes.draw do
  resources :applications, param: :token do
    resources :chats, param: :number, :except => [:update] do
      resources :messages, param: :number
    end
  end
end
