// Javascript libraries
import "core-js/stable";
import "regenerator-runtime/runtime";
import "jquery"
import "foundation-sites"

// CSS
import "src/application.scss"

// My plugins
import "plugins/map"
import "plugins/search"
import "plugins/search-slider"
import "plugins/editor"
import "plugins/places"
import "plugins/reveal-image"
import "plugins/emoji-picker"

function fireOnReady() {
  $(document).foundation();
  window.dispatchEvent(new Event('resize'));
}

if (document.readyState === 'complete') {
    fireOnReady();
} else {
    document.addEventListener("DOMContentLoaded", fireOnReady);
}
