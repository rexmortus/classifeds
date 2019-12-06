function previewImages() {

  var preview = document.getElementById('image-preview');

  if (preview) {
    preview.innerHTML = '';

    if (this.files) {
      [].forEach.call(this.files, readAndPreview);
    }

    function readAndPreview(file) {

      if (!/\.(jpe?g|png|gif)$/i.test(file.name)) {
        return alert(file.name + " is not an image");
      } // else...

      var reader = new FileReader();

      reader.addEventListener("load", function() {

        const div = document.createElement('div');
        div.classList.add('image-container');
        div.classList.add('js-reveal-photo');

        var image = new Image();
        image.height = 300;
        image.title  = file.name;
        image.src    = this.result;

        div.appendChild(image);

        preview.appendChild(div);
      });

      reader.readAsDataURL(file);

    }

    document.querySelector('#advertisement_images').addEventListener("change", previewImages);

  }

}
