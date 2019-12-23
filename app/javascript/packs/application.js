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
import "plugins/editor"
import "plugins/places"
import "plugins/reveal-image"
import "plugins/emoji-picker"
import "plugins/uploader"
import "plugins/images-container"
import "plugins/share-ad"
import "plugins/add-contact-methods"

function fireOnReady() {
  $(document).foundation();
}

if (document.readyState === 'complete') {
    fireOnReady();
} else {
    document.addEventListener("DOMContentLoaded", fireOnReady);
}
