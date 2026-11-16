
#!/bin/bash

for i in 1 2 3 4; do
    input_dir="Testcase${i}"
    output_dir="Testcase${i}Diff"

    rm -rf "$output_dir"

    for file1 in "$input_dir"/*.1.txt; do
        [ -f "$file1" ] || continue

        file2="${file1%.1.txt}.2.txt"
        [ -f "$file2" ] || continue

        name="${file1#*/}"
        name="${name%.1.txt}"
        output_file="$output_dir/${name}Diff.txt"

        if ! cmp -s "$file1" "$file2"; then
            mkdir -p "$output_dir"
            diff -u "$file1" "$file2" > "$output_file"
        fi
    done
done
