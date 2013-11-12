// function Hints() {
//   this.generateHints(44, 100, 12);
// }
var createHints = function() {
    showHints().done(function(data) {
      for (i=0;i<data.length;i++) {
        $matchDiv = $('<div>');
        $matchDiv.addClass('match');
        $matchPic = $('<img>');
        $matchPic.attr('src', data[i]['profile_picture']);
        $matchDiv.append($matchPic);
        $('.row').append($matchDiv);
      }
    });
    $(this).off();
};
