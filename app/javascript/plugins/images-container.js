import "jquery"
import Packery from "packery"
import imagesLoaded from "imagesloaded"

const container = document.getElementById('js-images-container');

if (container) {

  var pckry = new Packery(container, {
    itemSelector: '.image-container',
    gutter: 16,
    percentPosition: true,
  });

  imagesLoaded(container, function( instance ) {
    pckry.layout();
  });
}
