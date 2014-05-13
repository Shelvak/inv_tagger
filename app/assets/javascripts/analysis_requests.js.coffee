# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
new Rule
  condition: $('[data-append-to]').length
  load: ->
    @map.appendNestedRows ||= (e)->
      e.preventDefault()
      e.stopPropagation()

      button = $(this)

      $(button.data('append-to')).append(button.data('template'))

    $(document).on 'click', '[data-append-to]', @map.appendNestedRows

  unload: ->
    $(document).off 'click', '[data-append-to]', @map.appendNestedRows
