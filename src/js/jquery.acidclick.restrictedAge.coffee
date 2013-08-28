(($, window) ->
  $.extend $.fn, restrictedAge: (options) ->
    @defaultOptions = 
      title: ''
      text: ''
      agreeBtnText:  'agree'
      disagreeBtnText:  'disagree'
      disagreeUrl: ''
      persistent: false
    settings = $.extend({}, @defaultOptions, options)
    
    restrictedAgeConfirmed = ()->
      pattern = /restrictedAgeConfirmed=true/
      return pattern.test document.cookie

    @each (i, el) =>
      $el = $(el) 

      if restrictedAgeConfirmed() is true
        return

      # define elements
      $fullscreen = $ '<div id="restrictedAge" style="display:none"></div>'
      $wrapper = $ '<div class="restrictedAgeWrapper"></div>'
      $title = $ '<h2></h2>'
      $text = $ '<p class="restrictedAgeText"></p>'
      $agreeBtn = $ '<a href="#" class="agreeBtn"></a>'
      $disagreeBtn = $ '<a href="#" class="disagreeBtn"></a>'

      # set texts
      $title.html settings.title
      $text.html settings.text
      $agreeBtn.html settings.agreeBtnText
      $disagreeBtn.html settings.disagreeBtnText
      $disagreeBtn.attr 'href', settings.disagreeBtnUrl

      # bind events
      $agreeBtn.on 'click', (event)->
        event.preventDefault()
        date = new Date()
        plus = if settings.persistent then 1 else 365
        date.setDate date.getDate() + plus
        document.cookie = 'restrictedAgeConfirmed=true; expires='+date.toUTCString()
        $fullscreen.fadeOut()

      $fullscreen.append $wrapper
      $wrapper.append $title if settings.title isnt ''
      $wrapper.append $text
      $wrapper.append $agreeBtn
      $wrapper.append $disagreeBtn

      $el.append $fullscreen

      $fullscreen.fadeIn()
    
    @ # allow chaining
) this.jQuery or this.Zepto, this