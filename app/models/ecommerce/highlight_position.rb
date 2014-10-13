# -*- encoding : utf-8 -*-
class HighlightPosition < EnumerateIt::Base
  associate_values(
    :center       => [1, "Centro"],
    :left        => [2, "Esquerda"],
    :right  => [3, "Direita"]
  )
end