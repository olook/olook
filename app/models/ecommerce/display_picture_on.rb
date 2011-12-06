# -*- encoding : utf-8 -*-
class DisplayPictureOn < EnumerateIt::Base
  associate_values(
    :gallery_1      => [01, '45o / Frente'],
    :gallery_2      => [02, 'Por trás'],
    :gallery_3      => [03, 'Sola / Lado'],
    :gallery_4      => [04, 'Frente / De cima'],
    :gallery_5      => [05, 'Lado 1'],
    :gallery_6      => [06, 'Lado 2'],
    :gallery_7      => [07, 'De cima'],
    :member_banner  => [20, 'Member banner'],
    :visitor_banner => [21, 'Visitor banner']
  )
end
