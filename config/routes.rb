Ama::Application.routes.draw do
  root to: 'ama#index'
  get ':id' => 'ama#show'
end
