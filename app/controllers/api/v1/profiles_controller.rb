class Api::V1::ProfilesController < ApplicationController#Api::V1::BaseController
  before_action :doorkeeper_authorize!

  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def index
    @users = User.where.not(id: current_resource_owner)
    respond_with @users, root: 'users'
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end


end