#!/bin/bash

# Retrieve average advanced calculations (100 times) for all cars in the garage.
usage () {
    echo "Usage: $0 <API_URL>"
    echo ""
    echo "Retrieves the average advanced calculations for all cars in the garage."
    echo ""
    echo -e "-p|--parallel <task_count>\tThe number of concurrent task to use. (Default: 100)"
    echo -e "-c|--call-count <count>\tThe number of call to make. (Default: 1000)"
    echo ""
    echo "OPTIONS:"
    echo -e "-h|--help\t\t\tShow this help"
}

PARALLEL_TASKS=100
COUNT=1000


POSITIONAL=()
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -h|--help)
            usage
            exit 0
        ;;
        -p|--parallel)
            PARALLEL_TASKS="$2"
            shift # past argument
            shift # past value
        ;;
        -c|--call-count)
            COUNT="$2"
            shift # past argument
            shift # past value
        ;;
        *)
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
        ;;
    esac
done

if [ ${#POSITIONAL[@]} -eq 0 ] ; then
    echo "At least <API> is expected as argument"
    usage
    exit 1
fi
API_URL="${POSITIONAL[0]}"
if [ ${API_URL:${#API_URL}-1} == / ]; then
    API_URL=${API_URL::-1}
fi

if [ ${#POSITIONAL[@]} -gt 1 ] ; then
    echo "Unknown arguments: ${POSITIONAL[@]:1}"
    usage
    exit 1
fi

echo "Retrieving average advanced calculations for all cars in the garage.."
start_time=$(date +%s.%N)
seq 1 $COUNT | xargs -Iunused -P$PARALLEL_TASKS curl -s --retry 5 --retry-connrefused -X GET "$API_URL/cars/advanced-calculations" > /dev/null
end_time=$(date +%s.%N)
echo "Done in $(echo "$end_time - $start_time" | bc) seconds"