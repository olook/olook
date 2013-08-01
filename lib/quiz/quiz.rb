class Quiz
  FILE_DIR = "#{Rails.root}/config/whatsyourstyle.yml"
  AUTH_TOKEN = YAML::load(File.open(FILE_DIR))[Rails.env]["auth_token"]

  def questions
    quiz
  end

  private
  def quiz
    response = Net::HTTP.get_response(url)
    HashWithIndifferentAccess.new(JSON.parse response.body)
  end

  def url
    URI.parse "http://whatsyourstyle.olook.com.br:9000/v1/quizzes/1?api_token=#{AUTH_TOKEN}"
  end
end
