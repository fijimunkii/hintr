$( document ).ready(function() {
  // new Hint;
  $('#show-hints').on('click', createHints);
  $('body').on('click', '.match', function() {
    showHint(this);
  });
  $('body').on('mouseover', '.match', function() {
    $(this.children[0]).addClass('hover');
    $(this.children[1]).css('visibility', 'visible');
  });
  $('body').on('mouseout', '.match', function() {
    $(this.children[0]).removeClass('hover');
    $(this.children[1]).css('visibility', 'hidden');
  });
});
