class Api::V1::ProfilesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :except_current_user, only: :index

  authorize_resource class: User
  respond_to :json

  def me
    respond_with current_resource_owner
  end

  def index
    respond_with @profiles
  end

  protected

  def except_current_user
    @profiles = User.where.not(id: current_resource_owner.id)
  end

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_ability
    @ability ||= Ability.new(current_resource_owner)
  end
end