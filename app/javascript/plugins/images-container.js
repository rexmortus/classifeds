import Packery from "packery"
import imagesLoaded from "imagesloaded"

const container = document.getElementById('js-images-container');

if (container) {

  var pckry = new Packery(container, {
    itemSelector: '.image-container',
    gutter: '.gutter-sizer',
    percentPosition: true,
    transitionDuration: 0,
  });

  imagesLoaded(container, function( instance ) {
    pckry.layout();
  });
}
