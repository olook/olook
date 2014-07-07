# -*- encoding : utf-8 -*-
class Suggestion

  COLOR_WHITELIST = SeoUrl.whitelisted_colors.map(&:downcase)


  def initialize values
    @subcategory=values[:subcategory].try(:downcase)
    @color=values[:filter_color].try(:downcase)
  end

  def get
    if !COLOR_WHITELIST.include?(@color)
      return nil
    end

    if @color == Product::NOT_AVAILABLE.downcase || @color.nil? || @subcategory.nil?
      return nil
    end

    color = sanitize_color(@color)

    if is_female?(@subcategory)
      color = to_female(color)
    end

    "#{@subcategory} #{color}".titleize
  end

  def is_female? subcategory
    is_bag = subcategory =~ /bolsa/ 
    female_word = subcategory.end_with?('a')
    is_exception = ['clutch', 'ankle boot'].include?(subcategory)

    is_bag || female_word || is_exception
  end

  def to_female color
    {
      vermelho: 'vermelha', 
      branco: 'branca', 
      amarelo: 'amarela',
      preto: 'preta',
      estampado: 'estampada',
      metalizado: 'metalizada',
      roxo: 'roxa'

    }.fetch(color.to_sym, color)
  end

  def sanitize_color(color)
    {
      terrosos: 'tons terrosos',
      metalizados: 'metalizado'
    }.fetch(color.to_sym, color)
  end

end