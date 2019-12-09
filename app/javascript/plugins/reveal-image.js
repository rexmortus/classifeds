import "jquery"
import Flickity from "flickity"

const modal = document.getElementById('modal');

if (modal) {

  var elem = document.querySelector('.carousel');

  var flkty = new Flickity( elem, {
    // options
    cellAlign: 'center',
    contain: true
  });

  $('.js-reveal-carousel').on('click', function(event) {
    event.preventDefault();
    $(modal).foundation('open');
  })

  $('#modal').on('open.zf.reveal', function() {
    window.dispatchEvent(new Event('resize'));
  });
}
