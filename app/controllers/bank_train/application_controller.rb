module BankTrain
  class ApplicationController < ActionController::Base
    layout "bank_train/application"
    if defined? PlayAuth
      helper PlayAuth::SessionsHelper
    end
  end
end