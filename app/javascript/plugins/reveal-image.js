import "jquery"
import Flickity from "flickity"

const modal = document.getElementById('modal');

if (modal) {

  const elem = document.querySelector('.carousel');

  const flkty = new Flickity( elem, {
    cellAlign: 'center',
    contain: true
  });

  $('.js-reveal-carousel').on('click', function(event) {
    const slideId = event.target.parentElement.dataset.slideId
    flkty.select(slideId, true, true);
    $(modal).foundation('open');
  })

  $('#modal').on('open.zf.reveal', function() {
    window.dispatchEvent(new Event('resize'));
  });
}
