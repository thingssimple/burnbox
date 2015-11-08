BurnBox::Application.routes.draw do
  root "messages#new"

  get "faq" => "faq#index"

  get "messages/:slug" => "messages#show"
  get "messages/:slug/download", to: "messages#download", as: "download"
  resources :messages
end
