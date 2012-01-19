require 'net/http'
require 'uri'

module Wpns
  extend self
  BASEBATCH = { :tile => 1, :toast => 2, :raw => 3 }
  BATCHADDS = { :delay450 => 10, :delay900 => 20 }
  WP_TARGETS = { :toast => "toast", :tile => "token" }

  # Send a WP7 notification to the given URI.
  #
  # @param [String] the channel uri that the WP7 device generated
  # @param [Hash] the options for the following message types
  #   Toast :title => a bold message
  #         :message => the small message
  #         :param => a string parameter that is passed to the app
  #   Tile :image => a new image for the tile
  #        :count => a number to show on the tile
  #        :title => the new title of the tile
  #        :back_image => an image for the back of the tile
  #        :back_title => a title on the back of the tile
  #        :back_content => some content (text) for the back
  #   Raw :message => the full XML message body
  def send_notification(uri, params, type = :raw, delay = nil)
    msg = build_message params, type
    notification_class = calculate_delay type, delay

    uri = URI.parse uri
    http = Net::HTTP.new uri.host, uri.port
    headers = { 'Content-Type' => 'text/html',
      'Content-Length' => msg.bytesize.to_s,
      'X-NotificationClass' => notification_class.to_s }
    headers['X-WindowsPhone-Target'] = WP_TARGETS[type] unless type == :raw

    http.post(uri.path, msg, headers)
  end

  private
  def calculate_delay(type, delay)
    BASEBATCH[type] + (BATCHADDS[delay] || 0)
  end

  def build_message(params, type)
    wp_type = type.to_s.capitalize
    unless type == :raw
      msg_body="<?xml version='1.0' encoding='utf-8'?><wp:Notification xmlns:wp='WPNotification'><wp:#{wp_type}>"
      case type
      when :toast
        msg_body << "<wp:Text1>#{params[:title]}</wp:Text1>" +
          "<wp:Text2>#{params[:message]}</wp:Text2>" +
          "<wp:Param>#{params[:param]}</wp:Param>"
      when :tile
        msg_body << "<wp:BackgroundImage>#{params[:image]}</wp:BackgroundImage>" +
          "<wp:Count>#{params[:count].to_s}</wp:Count>" +
          "<wp:Title>#{params[:title]}</wp:Title>" +
          "<wp:BackBackgroundImage>#{params[:back_image]}</wp:BackBackgroundImage>" +
          "<wp:BackTitle>#{params[:back_title]}</wp:BackTitle>" +
          "<wp:BackContent>#{params[:back_content]}</wp:BackContent>"
      end
      msg_body << "</wp:#{wp_type}></wp:Notification>"
    else
      msg_body = params[:message]
    end
    msg_body
  end
end
