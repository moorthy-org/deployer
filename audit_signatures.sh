#!/usr/bin/env bash
trusted_keys=(
    "B4E191B0A435E1200D67E6C09ADE4EB4A812E02B"
)
exit_code=0
for hash in $(git log --format=format:%H --no-merges); do
    res=$(git verify-commit --raw $hash 2>&1)
    if [ $? -gt 0 ]; then
        echo $hash NO SIGNATURE FOUND
        exit_code=1
        continue
    fi
    author="$(echo $res | grep -Po 'VALIDSIG [0-9A-F]{40}' \
        |cut -d ' ' -f2)"
    is_trusted=0
    case "${trusted_keys[@]}" in
        *"$author"*) is_trusted=1
    ;; esac
    if [ $is_trusted -eq 1 ]; then
        echo "$hash TRUSTED $(gpg --fingerprint $author \
            |grep uid |head -1|awk '{print $2,$3,$4,$5}')"
    else
        echo $hash SIGNATURE AUTHOR NOT TRUSTED: $author
        exit_code=1
    fi
done
exit $exit_code
