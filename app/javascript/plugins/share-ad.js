import copy from 'copy-to-clipboard';

const shareAdvertisement = document.getElementById('js-share-advertisement');

if (shareAdvertisement) {

  shareAdvertisement.addEventListener('click', function(event) {
    event.preventDefault();
    copy(event.target.href);
    $(event.target).foundation('hide');
  });

}
