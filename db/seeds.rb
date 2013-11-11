# -*- encoding : utf-8 -*-
superadmin = Role.where(:name => "superadministrator").first_or_create(:description => "Manages the whole system")

Admin.where(:email => "admin@olook.com").first_or_create( :password =>"DifficultPassword123",
																										    :first_name => "administrator",
																										    :last_name => "olook",
																										    :role => superadmin)

SurveyBuilder.new( SURVEY_DATA, "Registration Survey" ).build

{ "Sexy" => "sexy",
	"Elegante" => "chic",
	"Básica" => "casual",
	"Fashionista" => "moderna" }.each do |key, value|
		Profile.find_by_name(key).try :update_attribute, :alternative_name, value
end

[ {:controller_name => 'moments', :description => 'Coleções e Catálogos'},
  {:controller_name => 'home', :description => 'Home não logada'},
  {:controller_name => 'members', :description => 'Minha vitrine'}
].each do |page_attributes|
  Page.where("controller_name = ?", page_attributes[:controller_name]).first_or_create(page_attributes)
end


# Promotion Rules and Promotion Actions
[
  {type: FirstBuy, name: "Primeira Compra"},
  {type: CartItemsAmount, name: "Quantidade de itens na sacola"},
  {type: CartItemsTotalValue, name: "Valor total dos items na sacola"},
  {type: FirstBuy, name: "Primeira Compra"},
  {type: SpecificItem, name: "Items especificos"},
  {type: SpecificCategory, name: "Items com categoria especifica"},
  {type: ActiveReseller, name: "Revendedor ativo"},

  #Actions
  {type: MinorPriceAdjustment, name: "Produto de menor valor Gratis"},
  {type: PercentageAdjustment, name: "Desconto em % do valor do pedido"},
  {type: PercentageAdjustmentOnFullPriceItems, name: "Desconto em % de produtos com preço cheio"},
  {type: ValueAdjustment, name: "Desconto de valor fixo"},
].each do | values |
  values[:type].first_or_create(name: values[:name])
end

# Promotion Actions
