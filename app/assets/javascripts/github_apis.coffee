#TODO: when this gets more unwieldy, rewrite with templates or React/angular etc

window.collapseForm = (collapseLink)->
  collapseLink = $(collapseLink)
  wrapper = collapseLink.parent()
  btn = wrapper.find("div.btn-primary")
  btn.show()
  insertLocation = wrapper.prev()
  wrapper.remove()
  insertLocation.after(btn)

window.expandForm = (btn, pattern)->
  btn = $(btn)
  btn.wrap("<div class='url-form-wrapper card'></div>")
  wrapper = btn.parent()
  wrapper.append("""
    <button onclick='collapseForm(this)' type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  """)

  wrapper.append("<div class='url-form'></div>")
  urlForm = btn.siblings(".url-form")

  btn.hide()
  urlForm.append("<h3>#{btn.html()}</h3>")

  template = urltemplate.parse(pattern)
  result = template.expand({})

  urlForm.append("<a href='#{result.url}' class='btn btn-sm btn-success'>#{result.url}</a>")

  for portion in result.urlPortions
    urlForm.append("""
    <input placeholder='#{portion}' onkeyup='updateUrl(this, "#{pattern}")'>
    """
    )

  $("input[autofocus=autofocus]").removeAttr("autofocus")
  urlForm.find("input:first").attr("autofocus", true)


window.updateUrl = (input, pattern)->
  template = urltemplate.parse(pattern)
  params = {}

  $(input).parent().find("input").map((_, e)->
    params[e.placeholder] = e.value
  )
  url = template.expand(params).url
  link = $(input).parent().find("a.btn-success")
  link.html url
  link.attr("href", url)


