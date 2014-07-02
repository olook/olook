# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cep do
    cep "12345678"
    endereco "Rua Teste"
    bairro "Bairro Teste"
    cidade "Cidade Teste"
    estado "TP"
    nome_estado "BRA"
  end
end
