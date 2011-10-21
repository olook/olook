# -*- encoding : utf-8 -*-
class DisplayPictureOn < EnumerateIt::Base
  associate_values(
    :gallery_1      => [01, 'Gallery 1'],
    :gallery_2      => [02, 'Gallery 2'],
    :gallery_3      => [03, 'Gallery 3'],
    :gallery_4      => [04, 'Gallery 4'],
    :gallery_5      => [05, 'Gallery 5'],
    :gallery_6      => [06, 'Gallery 6'],
    :gallery_7      => [07, 'Gallery 7'],
    :member_banner  => [20, 'Member banner'],
    :visitor_banner => [21, 'Visitor banner']
  )
end
