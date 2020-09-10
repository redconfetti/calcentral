class EnrollmentResourcesController < ApplicationController
  def index
    render json: Api::EnrollmentResources.new(user_id)
  end

  private

  def user_id
    session['user_id']
  end
end
