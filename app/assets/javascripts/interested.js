function setInterest(value) {
  // Server will start scraping and set user.interested_in
  return $.ajax({
    url: '/users/set_interest'+"?authenticity_token="+encodeURIComponent(AUTH_TOKEN),
    type: 'post',
    data: { interested_in: value }
  });
}


var interestedIn = function() {
  // Post the interested-in answer,
  // checkbox1 -- men, checkbox2 -- women
  // $('#checkbox1')[0].checked -- true or false
  var interestedInValue;
  if ($('#checkbox1')[0].checked && $('#checkbox2')[0].checked) {
    interestedInValue = "both";
    setInterest(interestedInValue).done(function(data) {
      location = '/';
    });
  } else if ($('#checkbox1')[0].checked) {
    interestedInValue = "male";
    setInterest(interestedInValue).done(function(data) {
      location = '/';
    });
  } else if ($('#checkbox2')[0].checked) {
    interestedInValue = "female";
    setInterest(interestedInValue).done(function(data) {
      location = '/';
    });
  } else {
    //TODO flash error message: "please make a selection"
  }


};