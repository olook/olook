function ImageLoader() {

  var ATTRIBUTE_NAME = 'data-async-url';

  this.load = function(class_name) {

    var containers = document.getElementsByClassName(class_name);

    for (var i = 0; i < containers.length; i++) {
      var container = containers[i];
      var url = container.getAttribute(ATTRIBUTE_NAME);
      load_image(container, url);
    };

  };

  load_image = function(img_tag, url) {
    img_tag.src = url;
  };

}