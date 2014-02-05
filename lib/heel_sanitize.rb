class HeelSanitize

  attr_accessor :word

  def initialize word
    @word = word
  end

  def perform
    return sanitize_with_word if match_with_correct_words?
    sanitize_with_number
  end

  private
  def match_with_correct_words?
    word.parameterize =~ /(baixo|medio|alto)/i
  end

  def sanitize_with_word
    parameterized_word = word.parameterize
    if parameterized_word =~ /baixo/i
      '0-4 cm'
    elsif parameterized_word =~ /medio/i
      '5-9 cm' 
    elsif parameterized_word =~ /alto/i
      '10-15 cm'
    else
      ''
    end
  end

  def sanitize_with_number
    sanitized_word = word.to_i
    if sanitized_word < 5
      '0-4 cm'
    elsif sanitized_word >= 5 && sanitized_word < 10
      '5-9 cm' 
    elsif sanitized_word >= 10
      '10-15 cm'
    else
      ''
    end
  end

end
