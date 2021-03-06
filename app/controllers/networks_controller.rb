#encoding: UTF-8
class NetworksController < ApplicationController
  load_and_authorize_resource
  before_filter :load_resources

  def show
    @network = Network.find(params[:id])
    @track = @mission.current_track
    update_progress_location
    mark_trait_as_found
    finish_mission
  end

  private

  def load_resources
    @mission = Mission.find(params[:mission_id])
    @progress = @mission.progress
    @headline = @mission.headline
  end

  def update_progress_location
    unless @progress.network == @network
      @time_traveled = @progress.location_travel(@network)
    end
  end

  def mark_trait_as_found
    if @network.trait?
      @network.trait_found
      @traits_found = @mission.traits_found
    end
  end

  def finish_mission
    if @network.final?
      @mission.finish
      redirect_to mission_path(@mission)
    end
  end

end
