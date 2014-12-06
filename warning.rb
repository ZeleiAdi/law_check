def warning(what, where)
  warn("\e[31m#{what}\e[0m")
  warn("\e[33m#{where}\e[0m")
end
