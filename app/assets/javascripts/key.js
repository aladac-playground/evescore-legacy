function check_api (key, vcode) {
  $.ajax(
    {
      url: "/api/verify",
      dataType: "HTML",
      data: { key: key, vcode: vcode },
      processDAta: true
    }
  ).done(function ( data ) {
    $('#out').html(data);
  });
};

$(document).ready(function(){
  $('#check_api').click(function() {
    check_api( $('#key_id').val(), $('#vcode').val() );
  });
});
