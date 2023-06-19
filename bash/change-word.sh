#!/bin/bash

file_path="nganu"  # Path ke file yang ingin diubah
word_list_path="deployment_list.txt"  # Path ke file yang berisi daftar kata

while IFS= read -r word; do
    new_file_path="${file_path%.*}_${word}.${file_path##*.}"
    sed "s/test/$word/g" "$file_path" > "$new_file_path"
done < "$word_list_path"
