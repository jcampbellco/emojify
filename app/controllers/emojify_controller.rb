class EmojifyController < ApplicationController
  def index
    # Strip extraneous characters from the command
    emoji = params[:text].downcase.gsub(/[^0-9a-z]/i, '')

    # Attempt to update the list only if the emoji does not exist
    update unless emojis[emoji].present?

    emoji_url = emojis[emoji]

    puts "URL? #{emoji_url}"

    # If we still don't have a URL for the requested emoji, let's generate a response to the user
    if emoji_url.present?
      response = {
        :attachments => [
          { :image_url => emoji_url }
        ],
        :response_type => :in_channel
      }
    else
      response = { :text => 'Emoji not found in list what the fuck', :response_type => :ephemeral }

    end

    render json: response
  end

  # URL to allow testing locally by providing this URL as the response and logging the generated actions
  def test_response
    puts params
  end

  private

  def emojis
    cache.read(:emoji_list)
  end

  def cache
    return @cache if @cache.present?
    @cache = ActiveSupport::Cache::MemoryStore.new
    @cache.write(:emoji_list, {})
    @cache
  end

  def update
    headers = {
      :authorization => "Bearer #{Rails.application.credentials[:slack][:token]}"
    }

    list = HTTParty.get('https://slack.com/api/emoji.list', :headers => headers).parsed_response

    cache.write(:emoji_list, list['emoji'])
  end
end
