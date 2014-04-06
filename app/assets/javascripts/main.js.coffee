# $(document).on 'page:change', ->
ready = ->
  $("form").submit ->
    $("form :input").each ->
      $(this).attr "disabled", "disabled"  if $(this).val() is ""
      return
    
  $("form #reset").click ->
    $(this).parents("form:first").find("input:text").val ""
    
  $(".date").datepicker {
    format: "yyyy-mm-dd",
    forceParse: false
  }
  $('.ttp').tooltip({ html: true })
  $('.alert').hide().slideDown().delay(3000).slideUp()
  $('#myTab a:first').tab('show')
  
  $(".collapse").on "shown.bs.collapse", ->
    icon_id = $(this).attr("data-icon")
    $(icon_id).removeClass("glyphicon-collapse-down").addClass "glyphicon-collapse-up"

  $(".collapse").on "hidden.bs.collapse", ->
    icon_id = $(this).attr("data-icon")
    $(icon_id).removeClass("glyphicon-collapse-up").addClass "glyphicon-collapse-down"
  
  repos = new Bloodhound(
    datumTokenizer: (d) ->
      d.tokens

    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote: "/search/ajax.json?q[name_cont]=%QUERY"
  )
  
  repos.initialize()
  $("#main-search > .typeahead").typeahead null,
    name: "twitter-oss"
    displayKey: "name"
    source: repos.ttAdapter()
    # onselect: $("#main-search").submit()
    templates:
      suggestion: Handlebars.compile([
        "<span><img src=\"http://image.eveonline.com/{{image}}/{{id}}_32.{{image_type}}\" class=\"img-rounded img-tt\"></span>"
        "<span class=\"search-name\">{{name}}</span>"
        "<span class=\"search-kind pull-right\"><i>{{kind}}</i></span>"
      ].join(""))
  # $("#main-search").bind "typeahead:selected", (obj, datum, name) ->
  #   $("#main-search").submit()
  #   return
  $(".typeahead").parents('form:first').bind "typeahead:selected", (obj, datum, name) ->
    $(this).submit()
    return

  # * * CONFIGURATION VARIABLES: EDIT BEFORE PASTING INTO YOUR WEBPAGE * * 
  disqus_shortname = "evescore" # required: replace example with your forum shortname

  # * * DON'T EDIT BELOW THIS LINE * * 
  (->
    dsq = document.createElement("script")
    dsq.type = "text/javascript"
    dsq.async = true
    dsq.src = "//" + disqus_shortname + ".disqus.com/embed.js"
    (document.getElementsByTagName("head")[0] or document.getElementsByTagName("body")[0]).appendChild dsq
    return
  )()
  
  # $("#main-search .tt-input").keypress (e) ->
  #   $("#main-search").submit()  if e.which is 13
  #   return
  
  rats = new Bloodhound(
    datumTokenizer: (d) ->
      d.tokens

    queryTokenizer: Bloodhound.tokenizers.whitespace
    remote: "/search/ajax_rats.json?q[name_cont]=%QUERY"
  )
  
  rats.initialize()
  $("#rat-search > .typeahead").typeahead null,
    name: "rat-search"
    displayKey: "name"
    source: rats.ttAdapter()
    # onselect: $("#main-search").submit()
    templates:
      suggestion: Handlebars.compile([
        "<span><img src=\"http://image.eveonline.com/{{image}}/{{id}}_32.{{image_type}}\" class=\"img-rounded img-tt\"></span>"
        "<span class=\"search-name\">{{name}}</span>"
      ].join(""))
  
  # $(".tt-input").keypress (e) ->
  #   $(this).parents('form:first').submit() if e.which is 13
  #   # $("#rat-search").submit()  if e.which is 13
  #   return
  

      
$(document).ready(ready)
$(document).on('page:load', ready)

