function renametab () {
    echo -ne "\033]0;"$@"\007"
}
