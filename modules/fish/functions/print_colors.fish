# @fish-lsp-disable 4001

set names black   red   green   yellow   blue   magenta   cyan   white \
          brblack brred brgreen bryellow brblue brmagenta brcyan brwhite

for i in (seq 0 15)
    set name $names[(math $i + 1)]

    if test $i -ge 7
        set fg 0
    else
        set fg 15
    end

    printf '%2d \033[38;5;%dm%-9s\033[0m \033[48;5;%d;38;5;%dm %-9s \033[0m\n' $i $i $name $i $fg $name
end
