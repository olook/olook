# -*- encoding : utf-8 -*-
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

    DEFAULT_QUIZ = {"name"=>"Whats your style?","description"=>"A quiz to discover Olook's customers style","questions"=>[{"id"=>7,"text"=>"De quem você gostaria de herdar o guarda roupa?","answers"=>[{"id"=>26,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/7C.jpg","text"=>"Da sexy Blake Lively"},{"id"=>27,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/7B.jpg","text"=>"Da descoladíssima Kate Moss"},{"id"=>28,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/7D.jpg","text"=>"Adoro o ar descolado casual da top Alessandra Ambrósio"},{"id"=>25,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/7A.jpg","text"=>"Da elegantíssima Kate Middleton"}]},{"id"=>4,"text"=>"Com qual dos sapatos abaixo você vai trabalhar?","answers"=>[{"id"=>13,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/4B.jpg","text"=>"Adoro sapatos diferentes"},{"id"=>14,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/4C.jpg","text"=>"Algo bem sexy combina com meu estilo"},{"id"=>16,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/4D.jpg","text"=>"Prefiro algo bem confortável como essa sapatilha"},{"id"=>15,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/4A.jpg","text"=>"Clássico, por favor"}]},{"id"=>8,"text"=>"Se você ganhasse um crédito de compras, em que marca você faria a festa?","answers"=>[{"id"=>32,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/8D.jpg","text"=>"Hering (casual e chic na medida certa)"},{"id"=>29,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/8A.jpg","text"=>"Zara (elegante e casual)"},{"id"=>30,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/8C.jpg","text"=>"Planet Girls (ousada e sexy)"},{"id"=>31,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/8B.jpg","text"=>"Urban Outfitters (cool e fashion)"}]},{"id"=>10,"text"=>"Com qual desses sapatos você se identifica mais?","answers"=>[{"id"=>40,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/10A.jpg","text"=>"Um clássico e elegante peep toe"},{"id"=>38,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/10C.jpg","text"=>"Um peep toe bem sexy"},{"id"=>39,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/10D.jpg","text"=>"Um slipper mais casual"},{"id"=>37,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/10B.jpg","text"=>"Uma bota bem descolada"}]},{"id"=>20,"text"=>"Qual o look ideal para o trabalho?","answers"=>[{"id"=>79,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/20C.jpg","text"=>"Sexy na medida certa"},{"id"=>80,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/20D.jpg","text"=>"Chic e mais básico"},{"id"=>77,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/20A.jpg","text"=>"Sofisticada e elegante"},{"id"=>78,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/20B.jpg","text"=>"Moderno e descolado"}]},{"id"=>11,"text"=>"Que tipo de salto você prefere?","answers"=>[{"id"=>41,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/11B.jpg","text"=>"Moderno e descolado"},{"id"=>44,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/11C.jpg","text"=>"Bem sensual"},{"id"=>43,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/11D.jpg","text"=>"Baixo e confortável"},{"id"=>42,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/11A.jpg","text"=>"Alto e elegante"}]},{"id"=>3,"text"=>"Qual dos looks você escolheria para usar no dia a dia?","answers"=>[{"id"=>10,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/3C.jpg","text"=>"Sensual na medida certa"},{"id"=>11,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/3B.jpg","text"=>"Amo moda e gosto de looks mais fashion"},{"id"=>12,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/3D.jpg","text"=>"Confortável e casual"},{"id"=>9,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/3A.jpg","text"=>"Chic e despretencioso"}]},{"id"=>1,"text"=>"Que tipo de roupa você prefere para sair a noite?","answers"=>[{"id"=>1,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/1B.jpg","text"=>"Moderna e descolada"},{"id"=>2,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/1A.jpg","text"=>"Elegante e chic"},{"id"=>3,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/1D.jpg","text"=>"Casual e descontraida"},{"id"=>4,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/1C.jpg","text"=>"Sexy, bem sexy"}]},{"id"=>12,"text"=>"Que tipo de sapatilha você prefere?","answers"=>[{"id"=>45,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/12C.jpg","text"=>"Sexy,  muito sexy"},{"id"=>47,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/12A.jpg","text"=>"Clássica"},{"id"=>48,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/12B.jpg","text"=>"Moderna e descolada"},{"id"=>46,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/12D.jpg","text"=>"Básica e cheia de charme"}]},{"id"=>13,"text"=>"Qual dos looks da Jennifer Lopez mais combina com você?","answers"=>[{"id"=>52,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/13C.jpg","text"=>"Sexy muito sexy"},{"id"=>49,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/13A.jpg","text"=>"Chic e comportado"},{"id"=>51,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/13B.jpg","text"=>"Fashion e cool"},{"id"=>50,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/13D.jpg","text"=>"Mais casual"}]},{"id"=>9,"text"=>"Sexta a noite, qual o sapato perfeito para sair?","answers"=>[{"id"=>34,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/9C.jpg","text"=>"Algo sexy e feminino"},{"id"=>36,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/9A.jpg","text"=>"Um clássico como o da foto"},{"id"=>33,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/9B.jpg","text"=>"Adoro algo moderno"},{"id"=>35,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/9D.jpg","text"=>"Confortável e lindo por favor!"}]},{"id"=>5,"text"=>"Qual das bolsas abaixo é perfeita para te acompanhar durante a semana?","answers"=>[{"id"=>20,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/5D.jpg","text"=>"A casual que combina com tudo"},{"id"=>19,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/5C.jpg","text"=>"Animal print, super sexy"},{"id"=>17,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/5A.jpg","text"=>"Clássica e sofisticada"},{"id"=>18,"image"=>"https://s3-sa-east-1.amazonaws.com/cdn.quiz.olook.com.br/assets/5B.jpg","text"=>"Moderna com esta da foto"}]}]}


    attr_reader :profile, :uuid
    attr_accessor :logger

    def initialize
      @logger = Logger.new(STDOUT)
    end

    def name
      quiz['name']
    end

    def questions
      @questions = []

      quiz['questions'].each do |question|
        @questions << WhatsYourStyle::Question.new({ 'id' => question['id'], 'text' => question['text'] }, question['answers'])
      end
      @questions
    rescue => e
      Rails.logger.error(quiz.inspect)
      raise e
    end

    def persisted?
      false
    end

    def profile_from(answers)
      @name = answers[:name] || answers['name']
      @answers = answers[:answers] || answers['answers']
      raise ArgumentError.new("missing :answers or :name key") if !@answers || !@name
      challenge
      { uuid: @uuid, profile: @profile }
    end

    private

      def logger_time(text, &block)
        start = Time.now.to_f
        yield
        time = (Time.now.to_f - start) * 1000
        logger.info("[#{ '%0.2f' % time } ms] #{text}")
      end

      def quiz
        return @quiz if @quiz
        url = URI.parse "#{SCHEMA}://#{HOST}:#{PORT}#{PREFIX_URL}/quizzes/1.json?api_token=#{AUTH_TOKEN}"
        response = nil
        logger_time("NET::HTTP.get_response(#{url})") do
          response = Net::HTTP.get_response(url)
        end
        @quiz = JSON.parse(response.body)
        rescue
          DEFAULT_QUIZ
      end

      def challenge
        j_response = get_challenge_response
        @profile = j_response['classification_label']
        @uuid = j_response['uuid']
      end

      def get_challenge_response
        path = "#{PREFIX_URL}/challenges/create?api_token=#{AUTH_TOKEN}"
        req = Net::HTTP::Post.new(path)
        req.add_field('Content-Type', 'application/json; charset=utf-8')
        req.add_field('Accept', 'application/json')
        req.body = challenge_payload
        response = nil
        logger_time("NET::HTTP.post(#{path})\n#{challenge_payload.inspect}") do
          response = Net::HTTP.new(HOST, PORT).start { |http| http.request(req) }
        end
        JSON.parse(response.body)
        rescue
          default_quiz_responder
      end

      def default_quiz_responder
        { "classification_label" => "casual/romantica", "uuid" => "00000000-e59f-0130-abc2-#{Random.rand(Random.rand(000000000000..999999999999))}"}
      end

      def challenge_payload
        JSON.generate({
           'challenge' => {
            'answers' => @answers
          }
        })
      end
  end
end
