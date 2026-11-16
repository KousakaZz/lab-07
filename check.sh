
#!/bin/bash

all_pass=1

for i in 1 2 3 4; do
    input_dir="Testcase${i}"
    output_dir="Testcase${i}Diff"
    passed=1
    has_diff=0

    for file1 in "$input_dir"/*.1.txt; do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        [ -f "$file2" ] || continue

        name="${file1##*/}"
        name="${name%.1.txt}"
        output_file="$output_dir/${name}Diff.txt"

        if ! cmp -s "$file1" "$file2"; then
            has_diff=1

            if [ ! -f "$output_file" ]; then
                passed=0
            elif ! cmp -s <(diff -u "$file1" "$file2" | tail -n +3) <(tail -n +3 "$output_file"); then
                passed=0
            fi
        else
            if [ -f "$output_file" ]; then
                passed=0
            fi
        fi
    done

    if [ "$has_diff" -eq 1 ]; then
        if [ ! -d "$output_dir" ]; then
            passed=0
        fi
    else
        if [ -d "$output_dir" ]; then
            passed=0
        fi
    fi

    if [ -d "$output_dir" ]; then
        for output_file in "$output_dir"/*; do
            [ -f "$output_file" ] || continue

            name="${output_file##*/}"
            name="${name%Diff.txt}"
            file1="$input_dir/${name}.1.txt"
            file2="$input_dir/${name}.2.txt"

            if [[ "$output_file" != *Diff.txt ]] ||
               [ ! -f "$file1" ] ||
               [ ! -f "$file2" ]; then
                passed=0
            fi
        done
    fi

    if [ "$passed" -eq 1 ]; then
        echo "Testcase${i}: PASS"
    else
        echo "Testcase${i}: FAIL"
        all_pass=0
    fi
done

if [ "$all_pass" -eq 1 ]; then
    exit 0
else
    exit 1
fi
