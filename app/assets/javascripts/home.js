$(function() {
  $("section.making_of a.open_making_of").live("click", function(e) {
    var url = $(this).attr("rel");
    var title = $("<div>").append($(this).siblings(".video_description").clone()).remove().html();
    var youtube_id = initBase.youtubeParser(url);
    content = initBase.youtubePlayer(youtube_id);
    content += title;
    initBase.modal(content);
    e.preventDefault();
  });
});
