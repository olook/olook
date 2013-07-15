# encoding: utf-8
require "spec_helper"

describe AssociateProductWithCollectionThemeService do
  before do
    @content = [ %{CodigoProduto	CodigoProdutoPai	Codigobarras	CodigoFabricante	TipoProduto	NomeProduto	Descricao	Classe	Marca	Familia	Grupo	SubGrupo	Peso	Comprimento	Largura	Espessura	QtdePorEmbalagem	QtdeMinimaEstoque	QtdeMaximaEstoque	UnidadeMedidaNome	UnidadeMedidaAbrev	CodigoCategoriaFiscal	ClassificacaoFiscal	DescritorSimples1	DescritorSimples2	DescritorSimples3	DescritorPreDefinido1	DescritorPreDefinido2	DescritorPreDefinido3	DescricaoComplementar1	DescricaoComplementar2	DescricaoComplementar3	DescricaoComplementar4	DescricaoComplementar5	DescricaoComplementar6	DescricaoComplementar7	DescricaoComplementar8	DescricaoComplementar9	DescricaoComplementar10	PrecoTabela1	PrecoPromocao1	InicioPromocao1	TerminoPromocao1	PrecoTabela2	PrecoPromocao2	InicioPromocao2	TerminoPromocao2	DiasGarantia	PrazoEntregaDias	ControlaEstoque	ProdutoSerBrinde	CategoriasSite	Interfaces	AtributoEstendido1	AtributoEstendido2	AtributoEstendido3	AtributoEstendido4	AtributoEstendido5	AtributoEstendido6	AtributoEstendido7	AtributoEstendido8	AtributoEstendido9	AtributoEstendido10	OrigemMercadoria\n},
                 %{91558			4907/SAIA PAETE COM BABADINHO EMBAIXO	P	SAIA PAETE COM BABADINHO EMBAIXO	Saia de paetê com babados	Roupa	HAES	Saia	Coleção Maio 2013	Default	0.1	1	1	1	1			UNIDADE	UNI		62045300	Dourado	Dourado	Dourado	Dourado		OLOOK	"P: Cós: 37cm / Quadril: 94cm / Comprimento: 36cm; M: Cós: 39cm / Quadril: 96cm / Comprimento: 36cm; G: Cós: 41cm / Quadril: 98cm / Comprimento: 36cm "			Saia	Minissaia paetê dourado com detalhe fluido na barra transparente.	100% POLIESTER			Fashionista, Sexy, Elegante		229.9												60	5											}
    ]
    @upload = mock
    file = mock
    file.stub!(:readlines).and_return(@content)
    @upload.stub!(:tempfile).and_return(file)
  end

  describe "#process!" do
    before do
      @product = FactoryGirl.create(:shoe, id: '91558')
      @collection_theme = FactoryGirl.create(:collection_theme, id: '60')
    end
    it 'should associate product with collection theme' do
      service = AssociateProductWithCollectionThemeService.new(@upload)
      service.process!
      expect(@product.collection_theme_ids).to include(60)
    end
  end
end
