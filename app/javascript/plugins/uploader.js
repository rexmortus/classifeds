import Packery from "packery";

const previewContainer = document.getElementById('js-image-preview');

let pckry;

if (previewContainer) {

  pckry = new Packery(previewContainer, {
    itemSelector: '.image-container',
    gutter: 16,
    percentPosition: true,
    transitionDuration: 0,
  });

}

const imageInput = document.getElementById('advertisement_images');

if (imageInput) {
  imageInput.addEventListener("change", previewImages);
}

const imageCounter = document.getElementById('js-images-count');

function previewImages() {

  previewContainer.innerHTML = '';
  pckry.items = [];

  imageCounter.innerHTML = this.files.length;

  if (this.files) {
    [].forEach.call(this.files, readAndPreview);
  }

  function readAndPreview(file) {

    if (!/\.(jpe?g|png|gif)$/i.test(file.name)) {
      return alert(file.name + " is not an image");
    } else {
      const reader = new FileReader();

      reader.addEventListener("load", function() {

        const div = document.createElement('div');
        div.classList.add('image-container');
        div.classList.add('packery-item');

        const image = new Image();
        image.height = 300;
        image.title  = file.name;
        image.src    = this.result;

        div.appendChild(image);

        previewContainer.appendChild(div);
        pckry.addItems(div);
        pckry.layout();

      });

      window.dispatchEvent(new Event('resize'));

      reader.readAsDataURL(file);
    }
  }
}
