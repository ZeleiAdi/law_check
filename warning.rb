def warning(what, *where)
  warn("\e[31m#{what}\e[0m")
  where.each do
    warn("\e[33m#{where}\e[0m")
  end
end
