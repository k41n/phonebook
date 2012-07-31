window.delayed_search = (elem) ->
  clearTimeout(window.delayed) if window.delayed
  window.delayed = setTimeout(->
    jQuery.post '/people/search',
      therm: elem.val()
  , 800)
