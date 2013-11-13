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
      var $modalDivLabel = $('#myModalLabel');
      $modalDivLabel.html(data['name']);
      var $modalDivBody = $('.modal-body');
      if (data['relationship_status'] && data['relationship_status'] !== null) {
        $modalDivBody.html('<h5>I\'m ' + data['relationship_status'] +'</h5>');
      } else {
        $modalDivBody.html('<h5>I\'m not telling you my relationship status. <br> So you can assume I\'m single!</h5>');
      }
    });
  });

  $('#interested-in-yes').on('click', function(e) {
    e.preventDefault();
    interestedIn();
  });

  $('body').on('mouseover', '.match', function() {
    var $img = $(this.children[0]);
    var $span = $(this.children[1]);
    $img.addClass('hover');
    $span.css('visibility', 'visible');
    if ($img.hasClass('green-ring') === true) {
      $span.css('color', '#2ecc71');
    } else {
      $span.css ('color', '#e74c3c');
    }
  });

  $('body').on('mouseout', '.match', function() {
    $(this.children[0]).removeClass('hover');
    $(this.children[1]).css('visibility', 'hidden');
  });



});
