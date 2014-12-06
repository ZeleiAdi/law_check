def warning(message, *occurrences)
  warn("\e[31m#{message}\e[0m")
  occurrences.each do |occurrence|
    warn("\e[33m#{occurrence}\e[0m")
  end
end
