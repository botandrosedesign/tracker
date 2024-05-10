class PivotalProjectsController < ApplicationController
  before_action do
    raise Pundit::NotAuthorizedError unless current_user.admin?
  end

  def refresh
    PivotalProject.refresh
    redirect_to :projects
  end

  def import
    @pivotal_project = PivotalProject.find(params[:id])
    @pivotal_project.import!
    project = @pivotal_project.project || @pivotal_project.build_project
    project.update!(name: @pivotal_project.name)
    redirect_to @pivotal_project
  end

  def show
    @pivotal_project = PivotalProject.find(params[:id])
  end

  private

  def must_pundit?
    false
  end
end

