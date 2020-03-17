Rails.application.routes.draw do
  get 'mecha' => 'mecha#show'
  get 'mecha/message' => 'mecha#message'
  post 'mecha' => 'mecha#show'
  get 'stuff/show' => 'stuff#show'
  post 'stuff/show' => 'stuff#show'
  get 'member' => 'member#show'
  post 'member' => 'member#show'
  get 'member/attend' => 'member#attend'
  post 'member/attend' => 'member#attend'
  get 'member/ninzu' => 'member#ninzu'
  get 'member/leave' => 'member#leave'
  root 'joinus#show'
  get 'joinus' => 'joinus#show'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
