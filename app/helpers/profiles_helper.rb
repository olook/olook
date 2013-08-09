module ProfilesHelper
  def render_profile_template(prof_name)
    case prof_name
    when 'sexy'
      render 'profiles/sexy'
    when 'chic'
      render 'elegante'
    when 'moderna'
      render 'fashion'
    else
      render 'casual'
    end
  end
end
