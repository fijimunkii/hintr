var createHints = function() {
    showHints().done(function(data) {
      for (i=0;i<data.length;i++) {
        $matchDiv = $('<div>');
        $matchDiv.addClass('match');
        $matchDiv.addClass('col-md-3 col-lg-3');
        $matchPic = $('<img>');
        $matchPic.attr('src', data[i]['profile_picture']);
        $matchPic.attr('class', 'img-circle');
        $matchDiv.append($matchPic);
        $('#hint-rows').append($matchDiv);
        $('#show-hints').addClass('hidden');
      }
    });
    $(this).off();
};
