var editorElement = document.getElementById('editor');

if (editorElement) {

  CKEDITOR.on('instanceReady', function(event) {
      var editor = event.editor;

      editor.on('focus', function(event) {
        $(event.editor.element).toggleClass('focussed');
      });

      editor.on('blur', function(event) {
        $(event.editor.element).toggleClass('focussed');
      });
  });

  CKEDITOR.replace('editor', {
    plugins: 'basicstyles,undo,link,wysiwygarea,toolbar',
  });

};
