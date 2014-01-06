function ImageLoader() {

  var ATTRIBUTE_NAME = 'data-async-url';

  this.load = function(class_name) {

    var containers = document.getElementsByClassName(class_name);

    for (var i = 0; i < containers.length; i++) {
      var container = containers[i];
      var url = container.getAttribute(ATTRIBUTE_NAME);

      var img_container;
      var attributes;
      if (container.tagName == 'DIV') {
        img_container = new Image();
        container.appendChild(img_container);
        attributes = {'data-backside-picture': container.getAttribute('data-backside-picture')};
      } else {
        img_container = container;
      }


      load_image(img_container, url, attributes);
    };

  };

  load_image = function(img_tag, url, attributes) {
    for(var k in attributes) img_tag.setAttribute(k, attributes[k])
    img_tag.src = url;
  };

}