#!/bin/bash

set -e

on_exit() {
    docker rm -f "${new_container}" "${old_container}" >/dev/null 2>&1 || true
    rm -rf ./new_dir ./old_dir ./image1.tar ./image2.tar
}

trap on_exit EXIT

compare_images() {

    new_image_name=$1
    old_image_name=$2
    is_pull_image=$3
    if [ "$is_pull_image" == "pull" ]; then
        docker pull "${new_image_name}"
        docker pull "${old_image_name}"
    fi
    TIMESTAMP="$(date +%y%m%d%H%M%S)"
    new_container="new_container_${TIMESTAMP}"
    old_container="old_container_${TIMESTAMP}"
    echo "INFO: Containers for comparison, new image name (ID): ${new_image_name}"
    echo "INFO: Containers for comparison, old image name (ID): ${old_image_name}"

    # Confirm continuation with user input 'y'
    read -p "INFO: Confirm versions of new and old containers, continue? (y/n)" -n 1 -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "INFO: User did not input 'y', exiting script"
        return 1
    fi

    docker rm -f "${new_container}" "${old_container}" >/dev/null 2>&1 || true
    docker run --entrypoint ls --name="${new_container}" "${new_image_name}" >/dev/null
    docker run --entrypoint ls --name="${old_container}" "${old_image_name}" >/dev/null
    sleep 2

    rm -rf ./new_dir ./old_dir ./image1.tar ./image2.tar ./result.log ./result
    echo "INFO: Exporting containers, please be patient..."
    docker export "${new_container}" >./image1.tar
    docker export "${old_container}" >./image2.tar

    mkdir -p ./new_dir ./old_dir ./result/update
    echo "INFO: Extracting containers, please be patient..."
    tar -xf image1.tar -C new_dir
    tar -xf image2.tar -C old_dir

    rm -rf ./new_dir/run ./new_dir/dev ./new_dir/proc ./new_dir/cache ./new_dir/lost+found ./new_dir/mnt ./new_dir/snap ./new_dir/tmp ./new_dir/var/run ./new_dir/var/proc ./new_dir/var/cache ./new_dir/var/crash ./new_dir/var/lock ./new_dir/var/tmp
    rm -rf ./old_dir/run ./old_dir/dev ./old_dir/proc ./old_dir/cache ./old_dir/lost+found ./old_dir/mnt ./old_dir/snap ./old_dir/tmp ./old_dir/var/run ./old_dir/var/proc ./old_dir/var/cache ./old_dir/var/crash ./old_dir/var/lock ./old_dir/var/tmp

    diff --no-dereference -rq new_dir old_dir >result.log && rc=$? || rc=$?
    if [ $rc -eq 0 ]; then
        echo "ERROR: No file differences found after comparison, new image name: ${new_image_name}, old image name: ${old_image_name}"
        return 1
    fi

    add_list=$(grep "^Only in new_dir" ./result.log | sed "s/: /\//" | awk -F " " '{print $3}')
    delete_list=$(grep "^Only in old_dir" ./result.log | sed "s/: /\//" | sed "s/: /\//" | sed 's/Only in old_dir//')
    update_list=$(grep '^Files.*differ$' ./result.log | awk -F " " '{print $2}')

    echo "INFO: Copying newly added files to directory [./result/update]"
    docker_upgrade_dir=./result/update
    mkdir -p "${docker_upgrade_dir}"
    add_count=0
    echo "New files to add:"
    for add_file in $add_list; do
        mkdir -p "${docker_upgrade_dir}$(dirname "${add_file#new_dir}")"
        echo "$add_file"
        cp -rfP "$add_file" "${docker_upgrade_dir}$(dirname "${add_file#new_dir}")"
        add_count=$((add_count + 1))
    done
    echo "Total number of new files: $add_count"
    echo "--------------------------------------------------------------------------"
    echo
    echo "INFO: Copying updated files to directory [./result/update]"
    echo "Files to update after container comparison:"
    update_count=0
    for update_file in $update_list; do
        mkdir -p "${docker_upgrade_dir}$(dirname "${update_file#new_dir}")"
        echo "$update_file"
        cp -rfP "$update_file" "${docker_upgrade_dir}$(dirname "${update_file#new_dir}")"
        update_count=$((update_count + 1))
    done
    echo "Total number of updated files: $update_count"
    echo "--------------------------------------------------------------------------"
    echo
    if [ "$delete_list" == "" ]; then
        echo "INFO: No files to delete found after container comparison"
    else
        echo -e "INFO: Found files to delete in container comparison: \n$delete_list"
    fi
    echo "----------------------------------Full comparison complete---------------------------------"
    echo "------------------------------------------------------------------------------------------"
}

compare_images "$1" "$2" "$3"
