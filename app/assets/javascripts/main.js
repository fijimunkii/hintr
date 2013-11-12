$( document ).ready(function() {
  // new Hint;
  $('#show-hints').on('click', createHints);
  $('body').on('click', '.match', function() {
    showHint(this);
  });
});
