$( document ).ready(function() {
  // new Hint;
  $('#show-hints').on('click', createHints);
  $('body').on('click', '.match', function() {
    showHint(this);
  });
  $('#interested-in-yes').on('click', function(e) {
    e.preventDefault();
    interestedIn();
  });
});
