$(function() {

  var showHint = function(hintDiv) {
    return $.ajax({
      url: '/users/' + $(hintDiv).attr('data-id'),
      type: 'get'
    });
  };


  // Open facebook message dialog on button click
  $('body').on('click', '.fb_message', function() {
    FB.ui({
      method: 'send',
      link: 'http://hintr.co',
      to: $(this).attr('data-fb_id')
    });
  });

  // TODO possibly set these events on the round picture, not the block
  // totally not necessary for MVP

  $('body').on('click', '.match', function() {
    showHint(this).done(function(data) {
      console.log(data);
      var $modalDivLabel = $('#myModalLabel');
      var $modalDivBody = $('.modal-body');
      var $modalDivImg = $('#modal-img');
      if (data[0]['relationship_status'] && data[0]['relationship_status'] !== null) {
        $modalDivLabel.html('<h5>' + data[0]['name'] + ': ' + data[0]['relationship_status'] +'</h5>');
      } else {
        $modalDivLabel.html('<h5>' + data[0]['name'] + ':</h5>' + '<p>I\'m not telling you my relationship status. <br> So you can assume I\'m single!</p>');
      }
      $modalDivImg.attr('src', data[0]['profile_picture']);
      $modalDivBody.append($modalDivImg);
      $modalDivImg.addClass('profile-pic');
      $('.fb_message').attr('data-fb_id', data[0]['fb_id']);
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
