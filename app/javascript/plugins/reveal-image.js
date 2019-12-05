import "jquery"

const modal = document.getElementById('modal');

if (modal) {

  $('.js-reveal-photo').on('click', function(event) {
    event.preventDefault();
    const clicked_src = event.target.parentElement.children[0].src
    const modal_img = modal.children[0].children[0].src = clicked_src

    $(modal).foundation('open');
  })
}
