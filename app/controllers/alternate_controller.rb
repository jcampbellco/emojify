class AlternateController < ApplicationController
  # https://api.slack.com/interactivity/slash-commands#app_command_handling
  def index
    render json: { :text => params[:text], :replace_original => "true", :response_type => :in_channel }
  end
end
