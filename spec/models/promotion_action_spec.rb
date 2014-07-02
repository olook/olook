require 'spec_helper'

describe PromotionAction do

  describe "#apply" do
    it { should respond_to(:apply).with(3).arguments }
  end

  describe "#simulate" do
    let(:cart) { mock_model Cart, items: [] }

    context "when cart has no items" do
      it "returns zero" do
        cart.items.should_receive(:any?).and_return(false)
        subject.simulate(cart, 0).should eq(0)
      end
    end
  end

  describe "#filter_items" do
    subject { described_class.new.filter_items(@cart_items, @filters) }

    context "with filter ''" do
      before do
        @cart_items = [
          mock_model(CartItem, product: mock_model(Product, category_humanize: 'sapato'))
        ]
        @filters = {'category' => ''}
      end
      it { expect(subject).to eq @cart_items}
    end

    context "with filter nil" do
      before do
        @cart_items = [
          mock_model(CartItem, product: mock_model(Product, subcategory: 'anabela'))
        ]
        @filters = {'subcategory' => nil}
      end
      it { expect(subject).to eq @cart_items}
    end

    context "filtering by full_price" do
      context "when is 0" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, price: 10, retail_price: 10))
          ]
          @filters = {'full_price' => '0'}
        end
        it { expect(subject).to eq [] }
      end

      context "when is 1" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, price: 20, retail_price: 10))
          ]
          @filters = {'full_price' => '1'}
        end
        it { expect(subject).to eq [] }
      end

      context "when is -1" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, price: 20, retail_price: 10))
          ]
          @filters = {'full_price' => '-1'}
        end
        it { expect(subject).to eq @cart_items }
      end
    end

    context "filtering by product_id" do
      context "without cart_item that has product_id" do
        before do
          @cart_items = [
            mock_model(CartItem, product_id: 99)
          ]
          @filters = {'product_id' => '9'}
        end
        it { expect(subject).to eq [] }
      end

      context "with cart_item that has product_id" do
        before do
          @cart_items = [
            mock_model(CartItem, product_id: 99)
          ]
          @filters = {'product_id' => '99'}
        end
        it { expect(subject).to eq @cart_items }
      end
    end

    context "filtering by subcategory" do
      context "without cart_item that has subcategory" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, subcategory: 'anabela'))
          ]
          @filters = {'subcategory' => 'bota'}
        end
        it { expect(subject).to eq [] }
      end

      context "with cart_item that has subcategory" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, subcategory: 'anabela'))
          ]
          @filters = {'subcategory' => 'anabela'}
        end
        it { expect(subject).to eq @cart_items }
      end

      context "ignoring subcategory if has product_id" do
        before do
          @cart_items = [
            mock_model(CartItem, product_id: 9, product: mock_model(Product, subcategory: 'anabela'))
          ]
          @filters = {'product_id' => '8', 'subcategory' => 'anabela'}
        end
        it { expect(subject).to eq [] }
      end
    end

    context "filtering by category" do
      context "without cart_item that has category" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, category_humanize: 'sapato'))
          ]
          @filters = {'category' => 'roupa'}
        end
        it { expect(subject).to eq [] }
      end

      context "with cart_item that has category" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, category_humanize: 'sapato'))
          ]
          @filters = {'category' => 'roupa,sapato'}
        end
        it { expect(subject).to eq @cart_items }
      end

      context "ignoring category if has subcategory" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, category_humanize: 'sapato', subcategory: 'anabela'))
          ]
          @filters = {'category' => 'sapato', 'subcategory' => 'bota'}
        end
        it { expect(subject).to eq [] }
      end
    end

    context "filtering by brand" do
      context "without cart_item that has brand" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, brand: 'olook'))
          ]
          @filters = {'brand' => 'tng'}
        end
        it { expect(subject).to eq [] }
      end

      context "with cart_item that has brand" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, brand: 'olook'))
          ]
          @filters = {'brand' => 'tng,olook'}
        end
        it { expect(subject).to eq @cart_items }
      end

      context "intersect with other filters" do
        before do
          @cart_items = [
            @sapato = mock_model(CartItem, product: mock_model(Product, category_humanize: 'sapato', brand: 'olook')),
            @roupa = mock_model(CartItem, product: mock_model(Product, category_humanize: 'roupa', brand: 'olook'))
          ]
          @filters = {'category' => 'sapato', 'brand' => 'olook'}
        end
        it { expect(subject).to eq [@sapato] }
      end
    end

    context "filtering by collection_theme" do
      context "without cart_item that has collection_theme" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, collection_themes: [mock_model(CollectionTheme, name: 'casual')]))
          ]
          @filters = {'collection_theme' => 'trabalho'}
        end
        it { expect(subject).to eq [] }
      end

      context "with cart_item that has collection_theme" do
        before do
          @cart_items = [
            mock_model(CartItem, product: mock_model(Product, collection_themes: [mock_model(CollectionTheme, slug: 'casual')]))
          ]
          @filters = {'collection_theme' => 'casual,trabalho'}
        end
        it { expect(subject).to eq @cart_items }
      end

      context "intersect with other filters" do
        before do
          @cart_items = [
            @olook = mock_model(CartItem, product: mock_model(Product, collection_themes: [mock_model(CollectionTheme, slug: 'casual')], brand: 'olook')),
            @tng = mock_model(CartItem, product: mock_model(Product, collection_themes: [mock_model(CollectionTheme, slug: 'casual')], brand: 'tng')),
          ]
          @filters = {'collection_theme' => 'casual', 'brand' => 'olook'}
        end
        it { expect(subject).to eq [@olook] }
      end
    end

    context "filtering by complete_look_products" do
      context "without cart_item that has all complete_look_products" do
        before do
          @cart_items = [
            mock_model(CartItem, product_id: 9, cart: mock(complete_look_product_ids_in_cart: [99, 98, 97]))
          ]
          @filters = {'complete_look_products' => '1'}
        end
        it { expect(subject).to eq [] }
      end

      context "with cart_item that has collection_theme" do
        before do
          @cart_items = [
            mock_model(CartItem, product_id: 99, cart: mock(complete_look_product_ids_in_cart: [99, 98, 97]))
          ]
          @filters = {'complete_look_products' => '1'}
        end
        it { expect(subject).to eq @cart_items }
      end

      context "intersect with other filters" do
        before do
          @cart_items = [
            @olook = mock_model(CartItem, cart: mock(complete_look_product_ids_in_cart: [99, 98, 97]), product_id: 99, product: mock_model(Product, brand: 'olook')),
            @tng = mock_model(CartItem, cart: mock(complete_look_product_ids_in_cart: [99, 98, 97]), product_id: 98, product: mock_model(Product, brand: 'tng')),
          ]
          @filters = {'complete_look_products' => '1', 'brand' => 'olook'}
        end
        it { expect(subject).to eq [@olook] }
      end
    end
  end
end
