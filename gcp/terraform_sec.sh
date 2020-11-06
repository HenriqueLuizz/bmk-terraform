#!/bin/bash

apply() {
    terraform apply -target=google_compute_instance.secondary -target=module.gcp-disk
}

destroy() {
    terraform destroy -target=google_compute_instance.secondary -target=module.gcp-disk
}

plan() {
    terraform plan -target=google_compute_instance.secondary -target=module.gcp-disk
}

helpFunction() {
    echo ""
    echo "Usage: $0 -m MODE 1|2|3 [1 - PLAN || 2 - APPLY || 3 - DESTROY]"
    echo -e "Executa o terraform plan|apply|destroy apenas para os modulos das instancias secundarias"
    echo -e ""
    echo -e "\t-m Mode Execute"
    echo -e ""
    echo -e "\t$0 -m plan \t$0 -m 1"
    echo -e "\t$0 -m apply \t$0 -m 2"
    echo -e "\t$0 -m destroy \t$0 -m 3"
    exit 1
}

while getopts "m:" opt
do
    case "$opt" in
        m ) parameterM="$OPTARG" ;;
        ? ) helpFunction ;;
    esac
done

if [ -z "$parameterM" ] ; then
    helpFunction
else
    case "$parameterM" in
        1 | plan ) plan ;;
        2 | apply ) apply ;;
        3 | destroy ) destroy ;;
        * ) helpFunction
    esac
fi