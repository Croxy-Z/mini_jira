# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end

  root to: redirect("/users/sign_in", status: 302)

  resources :projects do
    resources :tasks, except: :index do
      patch :move, on: :member
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
