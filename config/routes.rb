# frozen_string_literal: true

Rails.application.routes.draw do
  root "dashboard#index"

  devise_for :users

  resources :projects do
    resources :tasks, except: :index do
      patch :move, on: :member
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
