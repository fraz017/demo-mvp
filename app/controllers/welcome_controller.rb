class WelcomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:recognize]

  def index
  end

  def recognize
    # cloudKey = "f2fe7867ebe7e5926d6aaa36e0478081"
    # cloudSecret = "jvmFnUk8BFRkENthhmCQdrocahT1DTZf1cFtCJw80b7LYlWD3iQR2fQyzLs1pc59OjfxUESQcQGyRlVCqsdNsd0oiuWmonJCJHuThKVBx8lX7BiXYLAekSEsj9ZMr9j7"
    # cloudUrl = "http://00e7bae37b68f3cf44b5fcff939b79af.na1.crs.easyar.com:8080/search"
    # image = Base64.encode64(File.read(file.path))
    # parameters = {
    #   'timestamp' => Time.now.to_i,
    #   'appKey' => cloudKey,
    #   'image' => image
    # }
    # parameters['signature'] = getSign(parameters, cloudSecret)
    # uri = URI.parse(cloudUrl)
    # http = Net::HTTP.new(uri.host, uri.port)
    # request = Net::HTTP::Post.new(uri.request_uri, {'Content-Type' =>'application/json'})
    # request.body = parameters.to_json
    # # Send the request
    # response = http.request(request)
    # binding.pry
    # puts "***********************************************"
    # puts response.body

    # data = JSON.parse(response.body)
    # image_data = Base64.decode64(data['data:image/jpeg;base64,'.length .. -1])
    # new_file=File.new(Time.now.to_i, 'wb')
    # new_file.write(image_data)
    limit = Time.zone.now.beginning_of_day..Time.zone.now.end_of_day
    restriction = Restriction.first 
    if restriction.present?
      if restriction.unit == "minutes"
        limit = restriction.limit.minutes.ago..Time.zone.now
      elsif restriction.unit == "days"
        limit = restriction.limit.days.ago..Time.zone.now
      else
        limit = restriction.limit.hours.ago..Time.zone.now
      end 
    end
    @track = TrackView.where(device_id: params[:id], created_at: limit)
    if @track.present?
      render json: {msg: "<strong>Content</strong> has already been viewed. Please try again in #{restriction.limit} #{restriction.unit}"}
    elsif
      file = params[:image]
      image1 = MiniMagick::Image.open(file.path)
      image2 = MiniMagick::Image.open(file.path)
      image1.rotate '90'
      # image.resize "500x500"
      found = find(image1)
      if !found
        found = find(image2)
      end
      if found
        @track.create(device_id: params[:id])
        url = Content.first&.url
        url = "http://layslanded.visidots.com" if url.nil?
        render json: {url: url}
      else
        render json: {msg: "<strong>Logo</strong> not recognized. Please try again!"}
      end
    end
  end
  
  private
  def find(image)
    found = false
    client = Aws::Rekognition::Client.new
    resp = client.detect_text(
      image: { bytes: File.read(image.path) }
    )

    resp.text_detections.each do |label|
      if label.detected_text == "Lays"
        found = true
      end
    end
    resp = client.detect_text(
      image: { bytes: File.read(image.path) }
    )
    return found
  end
end
