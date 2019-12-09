import "jquery"
import Packery from "packery"

const container = document.getElementById('js-images-container');

if (container) {

  var pckry = new Packery( container, {
    // options
    itemSelector: '.image-container',
    gutter: 16,
    percentPosition: true,
  });

  pckry.layout();

}
