# -*- encoding : utf-8 -*-
class Event
  class Type < EnumerateIt::Base
    associate_values(
      signup:                 [10, 'Signup'],
      signin:                 [11, 'Signin'],
      signout:                [12, 'Signout'],

      send_invite:            [20, 'Send invites'],
      import_gmail_contacts:  [21, 'Import Gmail contacts'],
      import_yahoo_contacts:  [22, 'Import Yahoo! contacts'],
      import_msn_contacts:    [23, 'Import MSN contacts'],

      share_on_facebook_wall: [30, 'Share on Facebook wall'],
      send_facebook_message:  [31, 'Send Facebook message'],

      share_on_twitter:       [40, 'Share on Twitter'],
      share_on_orkut:         [50, 'Share on Orkut']
    )
  end  
end
