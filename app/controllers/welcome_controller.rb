require 'fuzzy_match'
class WelcomeController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:recognize]

  def index
    
  end

  def client
    @content = Content.where(name: params[:id]).first
    if @content.nil?
      redirect_to "/error"
    else
    end
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
    content = Content.find(params[:content_id])
    restriction = content.restriction
    if restriction.present?
      if restriction.unit == "minutes"
        limit = restriction.limit.minutes.ago..Time.zone.now
      elsif restriction.unit == "days"
        limit = restriction.limit.days.ago..Time.zone.now
      else
        limit = restriction.limit.hours.ago..Time.zone.now
      end 
    end
    @track = TrackView.where(device_id: params[:id], created_at: limit, content_id: params[:content_id])
    if @track.present?
      render json: {msg: "<strong>Content</strong> has already been viewed. Please try again later"}
    elsif
      file = params[:image]
      image1 = MiniMagick::Image.open(file.path)
      image2 = MiniMagick::Image.open(file.path)
      image1.rotate '90'
      # image.resize "500x500"
      # found = find(image1, content.text)
      found = find(image1, params[:content_id])
      if !found
        # found = find(image2, content.text)
        found = find(image2, params[:content_id])
      end
      if found.present?
        @track.create(device_id: params[:id], latitude: params[:latitude], longitude: params[:longitude])
        url = found
        url = "http://layslanded.visidots.com" if url.nil?
        render json: {url: url}
      else
        render json: {msg: "<strong>Please</strong> Locate Logo. Then Try Again!"}
      end
    end
  end

  private
  def find(image, content_id)
    redirects = Redirect.where(content_id: content_id)
    text = redirects.pluck(:text)
    hash = Hash.new
    redirects.each do |r|
      hash[r.text] = r.url
    end
    name = ""
    # found = false
    client = Aws::Rekognition::Client.new
    resp = client.detect_text(
      image: { bytes: File.read(image.path) }
    )

    r = resp.to_h  
    # lines = r[:text_detections].map {|f| f [:detected_text] if f[:type] == "LINE"  }.compact!
    words = r[:text_detections].map {|f| f [:detected_text] if f[:type] == "WORD"  }.compact!  
    # text.each do |t|
    lines.each do |l|
      name = FuzzyMatch.new(text).find(l)
      puts "**********************"
      puts "#{lines}"
      puts "**********************"
      puts "**********************"
      puts "#{l}"
    end  

    if name.nil?
      words.each do |w|
        name = FuzzyMatch.new(text).find(w)
        puts "**********************"
        puts "#{words}"
        puts "**********************"
        puts "**********************"
        puts "#{w}"
      end
    end

    puts "**********************"
    puts "**********************"
    puts "#{name}"
      # resp.text_detections.each do |label|
      #   array = t.downcase.split(" ")
      #   # removable = FuzzyMatch.new(array).find(label.detected_text.downcase.gsub(/[^0-9A-Za-z]/, ''))
      #   puts "**********************************"
      #   puts "*"
      #   puts "*            #{label}          #{array} ****"
      #   puts "*"
      #   puts "**********************************" 
      #   if label.detected_text.downcase.gsub(/[^0-9A-Za-z]/, '') == array[0].gsub(/[^0-9A-Za-z]/, '')
      #     array.shift
      #     # array = array - [removable]
      #     if array.length == 0
      #       found = true
      #       name = t
      #       break
      #     end
      #   end
      # end
      # if found
      #   break
      # end
    # end
    
    return hash[name]
  end
end
