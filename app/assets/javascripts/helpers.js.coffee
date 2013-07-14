@Helpers=
  removeLastWhiteCharacter: (element) ->
    if element[element.length - 1] == ' '
      @.removeLastWhiteCharacter(element.slice(0, -1))
    else
      element


