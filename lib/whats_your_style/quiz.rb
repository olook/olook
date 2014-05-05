# -*- encoding : utf-8 -*-
require 'yaml'
require 'net/http'
require 'uri'
require 'logger'
require File.expand_path(File.join(__dir__, 'question'))

module WhatsYourStyle
  class Quiz
    attr_reader :profile, :uuid, :default_quiz_response

    def initialize(options={})
      @logger = options[:logger] || Logger.new(STDOUT)
      @env = options[:env] || inspect_env || 'production'
      @config_dir = options[:config_dir]
      validates_config_dir

      @auth_token = load_config_yaml('whatsyourstyle.yml')[@env]["auth_token"]

      @schema = defaults['schema']
      @host = defaults['host']
      @port = defaults['port']
      @prefix_url = defaults['prefix_url']
      @default_quiz = defaults['default_quiz']
      @default_quiz_response = defaults['default_quiz_response']
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
      @logger.error(quiz.inspect)
      raise e
    end

    def profile_from(answers)
      @name = answers[:name] || answers['name']
      @answers = answers[:answers] || answers['answers']
      raise ArgumentError.new("missing :answers or :name key") if !@answers || !@name
      challenge
      { uuid: @uuid, profile: @profile }
    end

    private

    def inspect_env
      if defined?(Rails)
        Rails.env
      end
    end

    def load_config_yaml(file)
      YAML::load(File.open(File.join(@config_dir, file)))
    end

    def defaults
      @defaults ||= load_config_yaml('whatsyourstyle_defaults.yml')
    end

    def validates_config_dir
      raise ArgumentError.new('Missing :config_dir') if !@config_dir
      raise ArgumentError.new(":config_dir #{@config_dir} is not a directory") if !File.directory?(@config_dir)
    end

    def logger_time(text, &block)
      start = Time.now.to_f
      yield
      time = (Time.now.to_f - start) * 1000
      @logger.info("[#{ '%0.2f' % time } ms] #{text}")
    end

    def quiz
      return @quiz if @quiz
      url = URI.parse "#{@schema}://#{@host}:#{@port}#{@prefix_url}/quizzes/1.json?api_token=#{@auth_token}"
      response = nil
      logger_time("NET::HTTP.get_response(#{url})") do
        response = Net::HTTP.get_response(url)
      end
      @quiz = JSON.parse(response.body)
    rescue => error
      send_alert_mail('QUIZ', error)
      @default_quiz
    end

    def send_alert_mail(source, error)
      error_message = "Failed to achieve WhatsYourStyle Server for #{source}: #{error.class}"
      _body = "#{error.class}: #{error.message}\n#{error.backtrace.to_a.join("\n")}"
      ActionMailer::Base.mail(:from => "dev.notifications@olook.com.br",
                              :to => "nelson.haraguchi@olook.com.br,tiago.almeida@olook.com.br,rafael.manoel@olook.com.br",
                              :subject => "ErrorNotifier: #{error_message}", :body => _body).deliver
    rescue
      # Code specific for using with Rails
      # TODO: extract to another class
    end

    def challenge
      j_response = get_challenge_response
      @profile = j_response['classification_label']
      @uuid = j_response['uuid']
    end

    def get_challenge_response
      path = "#{@prefix_url}/challenges/create?api_token=#{@auth_token}"
      req = Net::HTTP::Post.new(path)
      req.add_field('Content-Type', 'application/json; charset=utf-8')
      req.add_field('Accept', 'application/json')
      req.body = challenge_payload
      response = nil
      logger_time("NET::HTTP.post(#{path})\n#{challenge_payload.inspect}") do
        response = Net::HTTP.new(@host, @port).start { |http| http.request(req) }
      end
      JSON.parse(response.body)
    rescue => error
      send_alert_mail('QUIZ RESPONSE', error)
      @default_quiz_response
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
