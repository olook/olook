//= require facebook_sdk
$("#facebook_share_profile").on("click", function(){
    switch(user_profile) {
      case "sexy":
        profile = "sexy";
        break;
      case "chic":
        profile = "elegante";
        break;
      case "moderna":
        profile = "fashion"
        break;
      default:
        profile = "casual"
    };
    share_profile_result(profile);
});
