# -*- encoding : utf-8 -*-
class DisplayDetailOn < EnumerateIt::Base
  associate_values(
    :invisible      => [0, 'Invisible'],
    :specification  => [1, 'Specification'],
    :how_to         => [2, 'How to use']
  )
end
