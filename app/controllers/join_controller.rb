class JoinController < ApplicationController
  layout 'quiz'
  before_filter do
    @hide_about_quiz = true
  end

  def new
    @user = User.new
  end
end
