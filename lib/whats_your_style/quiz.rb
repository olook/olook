module WhatsYourStyle
  class Quiz
    include ActiveModel::Validations
    include ActiveModel::Conversion
    extend ActiveModel::Naming

    FILE_DIR = "#{Rails.root}/config/whatsyourstyle.yml"
    AUTH_TOKEN = YAML::load(File.open(FILE_DIR))[Rails.env]["auth_token"]

    def name
      quiz[:name]
    end

    def questions
      @questions = []
      quiz[:questions].each do |question|
        @questions << Question.new({ id: question[:id], text: question[:text] }, question[:answers])
      end
      @questions
    end

    def persisted?
      false
    end

    private
      def quiz
        return @quiz if @quiz
        response = Net::HTTP.get_response(url)
        @quiz = HashWithIndifferentAccess.new(JSON.parse response.body)
      end

      def url
        URI.parse "http://whatsyourstyle.olook.com.br:9000/v1/quizzes/1?api_token=#{AUTH_TOKEN}"
      end
  end
end
