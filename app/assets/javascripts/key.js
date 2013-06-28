function check_api (key, vcode) {
  if ( key.length == 7 && vcode.length == 64 ) {
    $.ajax(
        {
          url: "/api/verify",
      dataType: "HTML",
      data: { key: key, vcode: vcode },
      processData: true
        }
        ).done(function ( data ) {
          result = JSON.parse(data);
          if ( result['valid'] == false ) {
            $('.notification-area').html('<div class="alert key"><button type="button" class="close" data-dismiss="alert">&times;</button>' + result['message'] + '</div>');
          } else if ( result['valid'] == true ) {
            character = result['character'];
            $('#api_submit').show();
            $('#api_check').hide();
            $('.notification-area').html('<div class="alert key alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>Key successfuly verified, press <b>Save</b></div>');
            $('#key').attr('readonly','true');
            $('#vcode').attr('readonly','true');
            $('#name').val(character['name']);
            $('#char_id').val(character['char_id']);
          }
        });
  } else {
    $('.notification-area').html('<div class="alert key alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button>Check the format</div>');
  }
};

$(document).ready(function(){
  $('#api_submit').hide();
  $('#api_check').click(function() {
    check_api( $('#key').val(), $('#vcode').val() );
  });
});
