function get_preview (preview_text, target_selector) {
  $.ajax(
    {
      url: "preview",
      dataType: "HTML",
      data: { preview: preview_text },
      processDAta: true
    }
  ).done(function ( data ) {
    $(target_selector).html(data);
  });
};
