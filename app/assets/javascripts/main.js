$( document ).ready(function() {

  $('#show-hints').on('click', createHints);
  $('body').on('click', '.match', function() {
    showHint(this);
  });

  $('#interested-in-yes').on('click', function(e) {
    e.preventDefault();
    interestedIn();

  $('body').on('mouseover', '.match', function() {
    $(this.children[0]).addClass('hover');
    $(this.children[1]).css('visibility', 'visible');
  });
  $('body').on('mouseout', '.match', function() {
    $(this.children[0]).removeClass('hover');
    $(this.children[1]).css('visibility', 'hidden');
  });
});
