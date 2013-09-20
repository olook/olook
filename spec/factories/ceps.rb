# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :cep do
    cep "MyString"
    endereco "MyString"
    bairro "MyString"
    cidade "MyString"
    estado "MyString"
    nome_estado "MyString"
  end
end
