# -*- encoding : utf-8 -*-
class DisplayPictureOn < EnumerateIt::Base
  associate_values(
    :gallery_1      => [01, 'Gallery 1 - 45o / Frente'],
    :gallery_2      => [02, 'Gallery 2 - Por trás'],
    :gallery_3      => [03, 'Gallery 3 - Sola / Lado'],
    :gallery_4      => [04, 'Gallery 4 - Frente / De cima'],
    :gallery_5      => [05, 'Gallery 5 - Lado 1'],
    :gallery_6      => [06, 'Gallery 6 - Lado 2'],
    :gallery_7      => [07, 'Gallery 7 - De cima'],
    :member_banner  => [20, 'Member banner'],
    :visitor_banner => [21, 'Visitor banner']
  )
end
