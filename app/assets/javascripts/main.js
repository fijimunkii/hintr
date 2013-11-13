$(function() {

  var showHint = function(hintDiv) {
    return $.ajax({
      url: '/users/' + $(hintDiv).attr('data-id'),
      type: 'get'
    });
  };

  // TODO possibly set these events on the round picture, not the block
  // totally not necessary for MVP

  $('body').on('click', '.match', function() {
    showHint(this).done(function(data) {
      console.log(data);
    });
  });

  $('#interested-in-yes').on('click', function(e) {
    e.preventDefault();
    interestedIn();
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
