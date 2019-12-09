// Javascript libraries
import "core-js/stable";
import "regenerator-runtime/runtime";
import "jquery"
import "foundation-sites"

// CSS
import "src/application.scss"
import 'file-upload-with-preview/dist/file-upload-with-preview.min.css'
import "flickity/dist/flickity.css"

// My plugins
import "plugins/map"
import "plugins/search"
import "plugins/search-slider"
import "plugins/editor"
import "plugins/places"
import "plugins/reveal-image"
import "plugins/emoji-picker"
import "plugins/uploader"
import "plugins/images-container"

function fireOnReady() {
  $(document).foundation();
  window.dispatchEvent(new Event('resize'));
}

if (document.readyState === 'complete') {
    fireOnReady();
} else {
    document.addEventListener("DOMContentLoaded", fireOnReady);
}
