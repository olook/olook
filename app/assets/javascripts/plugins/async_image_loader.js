function ImageLoader() {

  var ATTRIBUTE_NAME = 'data-product';

  this.load = function(class_name) {

    var containers = document.getElementsByClassName(class_name);

    for (var i = 0; i < containers.length; i++) {
      var container = containers[i];
      var url = container.getAttribute(ATTRIBUTE_NAME);

      var img_container;
      var attributes;
      if (container.tagName == 'DIV') {
        img_container = new Image();
        img_container.className = 'async'
        container.parentNode.replaceChild(img_container, container);
        attributes = {
          'data-backside-picture': container.getAttribute('data-backside-picture'),
          'data-product': container.getAttribute('data-product')
        };
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