# -*- encoding : utf-8 -*-
class EventType < EnumerateIt::Base
  associate_values(
    signup:                 [10, 'Sign up'],
    signin:                 [11, 'Sign in'],
    signout:                [12, 'Sign out'],

    first_visit:            [20, 'First visit'],

    send_invite:            [30, 'Send invites'],
    send_imported_contacts: [34, 'Send imported contacts'],
    import_gmail_contacts:  [35, 'Import Gmail contacts'],
    import_yahoo_contacts:  [36, 'Import Yahoo! contacts'],
    import_msn_contacts:    [37, 'Import MSN contacts'],

    share_on_facebook_wall: [40, 'Share on Facebook wall'],
    send_facebook_message:  [41, 'Send Facebook message'],

    share_on_twitter:       [50, 'Share on Twitter'],
    share_on_orkut:         [60, 'Share on Orkut']
  )
end
