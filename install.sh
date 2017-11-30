#!/bin/bash

source_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

backupFiles=( "${HOME}/.bash_profile" "${HOME}/.vimrc" )

for file in "${backupFiles[@]}"
do
    if [[ -f "$file" ]]
    then
        mv "${file}" "${file}.old"
    fi
done

cp "${source_dir}/bash_profile" "${HOME}/.bash_profile"

echo sed -ie "s@##source_dir##@$source_dir@g" "${HOME}/.bash_profile"
sed -ie "s@##source_dir##@$source_dir@g" "${HOME}/.bash_profile"

cp "${source_dir}/vimrc" "${HOME}/.vimrc"
