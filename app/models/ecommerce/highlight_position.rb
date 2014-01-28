# -*- encoding : utf-8 -*-
class HighlightPosition < EnumerateIt::Base
  associate_values(
    :center       => 1,
    :left        => 2,
    :right  => 3
  )
end