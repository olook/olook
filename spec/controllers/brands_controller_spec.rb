require 'spec_helper'

describe BrandsController do
  before do
    BrandsFormat.any_instance.stub(:get_sort_brands_from_cache).and_return(["284", "Afghan", "Agua Doce", "Basico Com", "Blue Man", "Botswana", "Canal", "Cantão", "Carina Duek", "Coca Cola Clothing", "Colcci", "Collins", "Couro", "Eclectic", "Ellus", "Ellus 2nd Floor", "Espaço Fashion", "Folic", "Forum", "Iódice Denim", "Juliana Jabour", "Juliana Manzini", "Lança Perfume", "Leeloo", "Lez A Lez", "M.Officer", "Mandi", "Mercatto", "Olli", "Olook", "Olook Concept", "Olook Essential", "Redley", "Scala", "Shop 126", "Shoulder", "Sommer", "Tan Tan", "Thelure", "Totem", "Triton", "Triya", "Tvz", "Wöllner"])
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end
end
