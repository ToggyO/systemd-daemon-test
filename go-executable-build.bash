#!/usr/bin/env bash

package=$1
source_file_name+=$package'.go'

if [[ -z "$package" ]]; then
    echo "usage: $0 <package-name>"
    exit 1
fi

package_split=(${package//\// })
package_name=${package_split[-1]}

platforms=("windows/amd64" "windows/386" "darwin/amd64" "linux/amd64")

go env -w GO111MODULE=off

for platform in "${platforms[@]}"
do
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}

    output_name=$package_name'-'$GOOS'-'$GOARCH

    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi

    env GOOS=$GOOS GOARCH=$GOARCH go build -o $output_name $source_file_name

    if [ $? -ne 0 ]; then
        echo 'An error has occurred! Aborting the script execution...'
        exit 1
    fi
done

go env -w GO111MODULE=on
/bin/bash
