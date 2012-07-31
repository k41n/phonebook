module ApplicationHelper
  def button_link(image, text, url, remote = true)
    link_to image_tag(image) + "<br/>#{text}".html_safe, url, class: 'button', remote: remote
  end

  def show_success(message)
    ret = <<-JS
      jQuery('body').append("<div id='success'>#{message}</div>")
      setTimeout(function(){
        jQuery('#success').remove()
      }, 5000)
    JS
    ret.html_safe
  end

  def show_warning(message)
    ret = <<-JS
      jQuery('body').append("<div id='warning'>#{message}</div>")
      setTimeout(function(){
        jQuery('#warning').remove()
      }, 5000)
    JS
    ret.html_safe
  end

  def show_error(message)
    ret = <<-JS
      jQuery('body').append("<div id='error'>#{message}</div>")
      setTimeout(function(){
        jQuery('#error').remove()
      }, 5000)
    JS
    ret.html_safe
  end

end
