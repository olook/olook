# -*- encoding : utf-8 -*-
class Suggestion

  COLOR_WHITELIST = SeoUrl.whitelisted_colors.map(&:downcase)

  def self.for values
    subcategory, color = extract(values)

    return nil if (invalid_color?(color) || invalid_subcategory?(subcategory))

    suggestion_term_for(subcategory, color)
  end

  private

  def self.extract(values)
    [values[:subcategory].try(:downcase), values[:filter_color].try(:downcase)]
  end

  def self.invalid_color?(color)
    color.blank? || !COLOR_WHITELIST.include?(color)
  end

  def self.invalid_subcategory?(subcategory)
    subcategory.blank?
  end

  def self.suggestion_term_for subcategory, color

    sanitized_color = sanitize_color(color)

    if is_female?(subcategory)
      color = to_female(sanitized_color)
    end

    "#{subcategory} #{color}".titleize
  end

  def self.is_female? subcategory
    is_bag = subcategory =~ /bolsa/ 
    female_word = subcategory.end_with?('a')
    is_exception = ['clutch', 'ankle boot'].include?(subcategory)

    is_bag || female_word || is_exception
  end

  def self.to_female color
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

  def self.sanitize_color(color)
    {
      terrosos: 'em tons terrosos',
      metalizados: 'metalizado'
    }.fetch(color.to_sym, color)
  end

end