#!/bin/bash

usage() {
    echo "Usage: $0 [options]"
    echo "Options:"
    echo "  -h, --help                Show this help message and exit"
    echo "  --vapor-api-url           The URL of the Vapor API"
    echo "  --hummingbird-api-url      The URL of the Hummingbird API"
    exit 1
}

VAPOR_API_URL=""
HUMMINGBIRD_API_URL=""

POSITIONAL=()
while [[ $# -gt 0 ]]; 
do
    key="$1"
    case $key in
        -h|--help)
            usage
            exit 0
        ;;
        --vapor|--vapor-api-url)
        VAPOR_API_URL="$2"
        shift # past argument
        shift # past value
        ;;
        --hummingbird|--hummingbird-api-url)
        HUMMINGBIRD_API_URL="$2"
        shift # past argument
        shift # past value
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done

if [ $(#POSITIONAL) -ne 0 ]; then
    echo "Unknown arguments: ${POSITIONAL[@]}"
    usage
    exit 1
fi

if [ -z "$VAPOR_API_URL" ]; then
    echo "Vapor API URL is required"
    usage
    exit 1
fi

if [ -z "$HUMMINGBIRD_API_URL" ]; then
    echo "Hummingbird API URL is required"
    usage
    exit 1
fi

echo "Launching test.."
echo "######################################"
echo "# This will take a while and appears #"
echo "# to hang, but don't worry!          #"
echo "######################################"

