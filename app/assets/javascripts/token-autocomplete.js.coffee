window.Autocomplete =
  tokenizeInputs: ->
    $('[data-token-autocomplete]:not([data-tokenized=true])').each ->
      input = $(this)
      input.tokenInput input.data('path'),
        prePopulate: input.data('load'),
        theme: 'facebook',
        propertyToSearch: 'label',
        preventDuplicates: true,
        tokenLimit: null,
        minChars: 3,
        hintText: false,
        noResultsText: input.data('no-result'),
        searchingText: false
      input.data('tokenized', true)

jQuery ($) ->
  # Doble iniciador por turbolinks
  Autocomplete.tokenizeInputs()

  $(document).on 'page:change', ->
    Autocomplete.tokenizeInputs()
