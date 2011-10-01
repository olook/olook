class MemberController < ApplicationController
  def invite
    @member = current_user
  end
end
