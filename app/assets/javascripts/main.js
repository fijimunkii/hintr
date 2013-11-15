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
    var matchId = $(this).attr('data-match_id');
    showHint(this).done(function(data) {
      console.log(data[2][0]);
      var $modalDivLabel = $('#myModalLabel');
      var $modalDivBody = $('.modal-body');
      $modalDivBody.text('');
      $modalDivBody.attr('data-match_id', matchId);
      var $sharedLikes = $('<p>');
      for (i=0; i<data[2].length;i++) {
        if (i===0) {
          $sharedLikes.text('You both are interested in: ' + data[2][i] + 's');
        } else {
          $sharedLikes.text($sharedLikes.text() +', ' + data[2][i] + 's');
        }
      }
        $modalDivBody.append($sharedLikes);

        if (data[0]['relationship_status'] && data[0]['relationship_status'] !== null) {
          $modalDivLabel.html('<h5>' + data[0]['name'] + ': ' + data[0]['relationship_status'] +'</h5>');
        } else {
          $modalDivLabel.html('<h5>' + data[0]['name'] + ':</h5>' + '<p>I\'m not telling you my relationship status. <br> So you can assume I\'m single!</p>');
        }
// TODO add conditional for undefined url
        for (i=0;i<data[1].length;i++) {
          $newImageDiv = $('<div>');
          $newImageDiv.addClass('crop');
          $newImageDiv.addClass('img-thumbnail');
          $newImage = $('<img>');
          $newImage.addClass('modal-image');
          $newImage.attr('src', data[1][i]['url']);
          $newImageDiv.append($newImage);
          $modalDivBody.append($newImageDiv);
        }
      $modalDivBody.scrollTop();
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
