# frozen_string_literal: true

class Admin::Api::V1::BaseController < ActionController::API
  include ControllerHelper

  before_action :require_admin!
end
