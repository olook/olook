class WhatsYourStyle
  FILE_DIR = "#{Rails.root}/config/whatsyourstyle.yml"

  def quiz
    response = Net::HTTP.get_response(url)
    HashWithIndifferentAccess.new(JSON.parse response.body)
  end

  private

    def url
      URI.parse "http://whatsyourstyle.olook.com.br:9000/v1/quizzes/1?api_token=#{auth_token}"
    end

    def auth_token
      config = YAML::load(File.open(FILE_DIR))
      env = config[Rails.env]["auth_token"]
    end
end
