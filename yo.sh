#!/usr/bin/env bash

declare -a fileSystems=('x' 'y' 'z')

for idx in "${!fileSystems[@]}"; do
    printf 'FS number %d is %s\n' "$idx" "${fileSystems[idx]}"
done
