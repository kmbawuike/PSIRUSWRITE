class Api::V1::WelcomeController < ApplicationController

  def welcome
    json_response "Welcome to PSIRUSWRITE API", true, {}, :ok
  end
end
