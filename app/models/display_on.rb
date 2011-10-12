# -*- encoding : utf-8 -*-
class DisplayOn < EnumerateIt::Base
  associate_values(
    :gallery        => [1, 'Gallery'],
    :member_banner  => [2, 'Member banner'],
    :visitor_banner => [3, 'Visitor banner']
  )
end
