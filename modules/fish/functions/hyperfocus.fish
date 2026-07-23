# @fish-lsp-disable 4001

while true
  sleep 30m
  if test (hostname) = patrick-desktop
    veila lock
  else
    notify-send --icon=computer "Hyperfocus" "Time for a short break! It's $(date "+%R")"
  end
end
