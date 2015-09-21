module BankTrain
  class Engine < ::Rails::Engine
    isolate_namespace BankTrain
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper

      User.class_eval do
        include BankTrain::Post::UserMethods
        include BankTrain::Level::UserMethods
        include BankTrain::BusinessCategory::UserMethods
        include BankTrain::BusinessOperation::UserMethods
      end
    end
    config.i18n.default_locale = "zh-CN"
  end
end
