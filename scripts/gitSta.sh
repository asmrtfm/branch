#!/usr/bin/env bash

Usage() { printf 'USAGE:  gitSta.sh  <[new]/branch/name>  [<?specific files>:|.]\n'; }

[[ "${1,,}" != +(\-)@(h)?(elp) ]] || { cat <<'EOL'
### ### ###
### First of all, fuck `git stash`
### ###
## presumably, you could even do an add+patch on a per-file basis
##   which would be useful if you fucked around and have uncommited changes
##	 that belong on different branches.

# * In any case,
#	  the basic catch all `add .` -based flow, demonstrated here,
##		 probably does what you expected `git stash / apply` to do
###                             the first and last time you ran it.
##
#

EOL
	exit 0
}

psAsk() {
	printf '\e[1;7;43m%666s\e[1;31;5m *  AYY \e[2;33m ! ! !%666s\e[1;7;43;26m\e[m\n\n\t\e[m Have you already committed any of your foibles?\e[m\n'
	read -p "(y/n): " Ans
	[[ "${Ans:-yes}" == @([nN])?([oO]) ]] || exit 3
}; psAsk

exit 0

[[ -e "$1" ]] || exit 1

git add ${2:-.} || exit 2

p="$(date +'%Y%m%d')_$(uuid).patch"

echo "Writing patch: '$p'"

git diff --cached > "$p" && echo "Success." || exit 3

git reset --hard

git checkout -b "$1"

git apply "$p"
