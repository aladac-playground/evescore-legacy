// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

$(document).ready(function(){
  $('.search-main').bind('typeahead:selected', function(obj, datum) {        
          // alert(JSON.stringify(obj)); // object
          // outputs, e.g., {"type":"typeahead:selected","timeStamp":1371822938628,"jQuery19105037956037711017":true,"isTrigger":true,"namespace":"","namespace_re":null,"target":{"jQuery19105037956037711017":46},"delegateTarget":{"jQuery19105037956037711017":46},"currentTarget":
          // alert(JSON.stringify(datum)); // contains datum value, tokens and custom fields
          $(".search-main").attr('action', datum["path"]);
          $(".tt-query").attr('name', datum["field_name"]);
          $(".tt-query").val(datum["field_value"]);
          
          // outputs, e.g., {"redirect_url":"http://localhost/test/topic/test_topic","image_url":"http://localhost/test/upload/images/t_FWnYhhqd.jpg","description":"A test description","value":"A test value","tokens":["A","test","value"]}
          // in this case I created custom fields called 'redirect_url', 'image_url', 'description'       
  });
  $('.search-main').keydown(function() {
      if (event.keyCode == 13) {
          this.submit();
          return false;
       }
  });
  $('.tt-hint').hide();
	$('.ttp').tooltip({ placement: 'top', html: true});
  $('.typeahead').typeahead({
    name: 'name',
    remote: '/api/search.json?text=%QUERY', cache: true,
    // template: [
    // '<img class="img img-rounded" src="({image})">',
    //   '<p class="repo-language">{{type}}</p>',
    //   '<p class="repo-name">{{name}}</p>'
    // ].join(''),
    template: [
    '<p class="type">{{type}}</p>',
    '<p class="name">{{name}}</p>'
    ].join(''),
    engine: Hogan
  });

  // $('.typeahead').typeahead();
// $('#search').typeahead({                              
//   name: 'character-search',                                                        
//   prefetch: '/character/all.json',
// 	valueKey: 'char_id',
//   template: [
// 		'<p><img src="http://image.eveonline.com/Character/{{id}}_64.jpg" style="margin-right: 20px" class="img-rounded">',
// 		'{{name}}'
//     // '<p class="character-name">{{name}}</p>',                              
//     // '<p class="character-id">{{id}}</p>',                                      
//   ].join(''),                                                                 
//   engine: Hogan                                                               
// });

});

