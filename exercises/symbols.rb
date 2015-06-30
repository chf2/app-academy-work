def super_print (string, options = {})
  defaults = {
    times: 2,
    upcase: true,
    reverse: true
  }

  new_opts = defaults.merge(options)

  string = string.upcase if new_opts[:upcase]
  string = string.reverse if new_opts[:reverse]
  new_opts[:times].times do
    puts string
  end
end
