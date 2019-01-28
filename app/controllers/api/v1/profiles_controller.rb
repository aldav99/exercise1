class Api::V1::ProfilesController < Api::V1::BaseController

  def me
    respond_with current_resource_owner
  end

  def show
    @users = User.where.not(id: current_resource_owner)
    respond_with @users, root: 'users'
  end
end