import EmojiButton from '@joeattardi/emoji-button';

const editPageButton = document.querySelector('.js-emoji-picker');

// Loads on EDIT page
if (editPageButton) {

  const input = document.getElementById('advertisement_emoji');

  const picker = new EmojiButton({
    showPreview: false,
    showSearch: true,
    showRecents: false,
    showVariants: false,
  });

   picker.on('emoji', emoji => {
     editPageButton.textContent = emoji;
     input.value = emoji;
   });

   editPageButton.addEventListener('click', (event) => {
     event.preventDefault();
     picker.pickerVisible ? picker.hidePicker() : picker.showPicker(editPageButton);
   });

}

 // Loads on SHOW page
const addReactionButton = document.getElementById('js-top-emoji');

if (addReactionButton) {

  const picker = new EmojiButton({
    showPreview: false,
    showSearch: true,
  });

   picker.on('emoji', emoji => {
     const input = document.getElementById('emoji_emoji');
     input.value = emoji;
     Rails.fire(input.closest('form'), 'submit');
   })

   const existing_emoji = document.getElementById('js-top-emoji');

   existing_emoji.addEventListener('click', function(event) {

     const input = document.getElementById('emoji_emoji');

     if (event.target.classList.contains('new-reaction')) {
       picker.pickerVisible ? picker.hidePicker() : picker.showPicker(event.target);
     } else {
       if (event.target.dataset.emoji !== undefined) {
         let emoji = event.target.dataset.emoji;
         input.value = emoji;
         Rails.fire(input.closest('form'), 'submit');
       }
     }

   })

}
