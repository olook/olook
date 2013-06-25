# -*- encoding : utf-8 -*-
class HighlightType < EnumerateIt::Base
  associate_values(
    :carousel   => [1, 'Carrossel'],
    :weekly     => [2, 'Semanal']
  )
 
end