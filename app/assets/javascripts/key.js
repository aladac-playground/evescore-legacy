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
            $('.notification-area').html('<div class="alert"><button type="button" class="close" data-dismiss="alert">&times;</button>' + result['message'] + '</div>');
          } else if ( result['valid'] == true ) {
            character = result['character'];
            $('#api_submit').show();
            $('#api_check').hide();
            $('.notification-area').html('<div class="alert alert-success"><button type="button" class="close" data-dismiss="alert">&times;</button>Success</div>');
            $('#key_id').attr('disabled','true');
            $('#vcode').attr('disabled','true');
            $('#portrait').html('<img src="http://image.eveonline.com/Character/' + character['char_id'] + '_128.jpg">');
            $('#name').html(character['name']);
          }
        });
  } else {
    $('.notification-area').html('<div class="alert alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button>Check the format</div>');
  }
};

$(document).ready(function(){
  $('#api_submit').hide();
  $('#api_check').click(function() {
    check_api( $('#key_id').val(), $('#vcode').val() );
  });
});
