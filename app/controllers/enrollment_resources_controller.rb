class EnrollmentResourcesController < ApplicationController

  # /api/:uid/enrollment_resources.json
  def show
    render json: Api::EnrollmentResources.new(user_id)
  end

  private

  def user_id
    session['user_id']
  end
end
