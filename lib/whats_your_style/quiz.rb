module WhatsYourStyle
  class Quiz
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    FILE_DIR = "#{Rails.root}/config/whatsyourstyle.yml"
    AUTH_TOKEN = YAML::load(File.open(FILE_DIR))[Rails.env]["auth_token"]
    SCHEMA = 'http'
    HOST = "whatsyourstyle.olook.com.br"
    PORT = "9000"
    PREFIX_URL = '/v1'

    attr_reader :profile, :uuid

    def name
      quiz['name']
    end

    def questions
      @questions = []

      quiz['questions'].each do |question|
        @questions << Question.new({ 'id' => question['id'], 'text' => question['text'] }, question['answers'])
      end
      @questions
    end

    def persisted?
      false
    end

    def profile_from(answers)
      @name = answers[:name] || answers['name']
      @answers = answers[:answers] || answers['answers']
      raise ArgumentError.new("missing :answers or :name key") if !answers || !name
      challenge
      { uuid: @uuid, profile: @profile }
    end

    private
      def quiz
        return @quiz if @quiz
        url = URI.parse "#{SCHEMA}://#{HOST}:#{PORT}#{PREFIX_URL}/quizzes/1?api_token=#{AUTH_TOKEN}"
        response = Net::HTTP.get_response(url)
        @quiz = JSON.parse(response.body)
      end

      def challenge
        path = "/v1/challenges/create?api_token=#{AUTH_TOKEN}"
        req = Net::HTTP::Post.new(path)
        req.body = challenge_payload
        response = Net::HTTP.new(HOST, PORT).start { |http| http.request(req) }
        j_response = JSON.parse(response.body)
        @profile = j_response['classification_label']
        @uuid = j_response['uuid']
      end

      def challenge_payload
        JSON.generate({
          @name => {
            answers: @answers
          }
        })
      end
  end
end
