@Helpers=
  removeLastWhiteCharacter: (string) ->
    if string[string.length - 1] == ' '
      @.removeLastWhiteCharacter(string.slice(0, -1))
    else
      string


