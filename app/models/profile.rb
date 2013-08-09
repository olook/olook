# -*- encoding : utf-8 -*-
class Profile < ActiveRecord::Base
  has_many :points
  has_many :users, :through => :points
  has_many :weights
  has_many :answers, :through => :weights

  has_and_belongs_to_many :products

  validates_presence_of :name, :first_visit_banner

  DESCRIPTION =
  {
    "casual" => 'Prática, Despojada, Independente, e adoto o lema "menos é mais"',
    "contemporary" => 'Antenada, Criativa, Confiante e AMO moda',
    "elegant" => 'Chic, Bem Sucedida, Elegante e Exigente',
    "feminine" => 'Vaidosa, Romântica, Alegre e Delicada',
    "sexy" => 'Sexy, Extravagante, Segura e Vivaz',
    "traditional" => 'Sofisticada, Conservadora, Discreta e Clássica',
    "trendy" => 'Segura, Ousada, Sexy e Moderna' 
  } 

  GOOGLE_CONVERSION_LABEL =
  {
    :casual => "UK1TCKHfyAIQn-uR5QM",
    :contemporary => "56iCCJngyAIQn-uR5QM",
    :elegant => "x6jPCJHhyAIQn-uR5QM",
    :feminine => "hwAvCIniyAIQn-uR5QM",
    :sexy => "bHl0CIHjyAIQn-uR5QM",
    :traditional => "ij-JCPnjyAIQn-uR5QM",
    :trendy => "Ul-eCPHkyAIQn-uR5QM"
  }

  def self.for_wysprofile(profile)
    {
      'casual/romantica' => '',
      'sexy' => '',
      'elegante' => '',
      'fashion' => ''
    }
  end
end
