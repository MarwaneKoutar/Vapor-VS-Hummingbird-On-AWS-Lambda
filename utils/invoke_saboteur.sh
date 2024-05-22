#!/bin/bash

usage () {
    echo "Usage: $0 <API_URL>"
    echo ""
    echo "Start the saboteur scenario where the saboteur visits the garage and paints all cars in the garage with a random color."
    echo ""
    echo -e "-p|--parallel <task_count>\tThe number of concurrent tasks to use. (Default: 20)"
    echo ""
    echo "OPTIONS:"
    echo -e "-h|--help\t\t\tShow this help"
}

PARALLEL_TASKS=20

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
        *)
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
        ;;
    esac
done

if [ ${#POSITIONAL[@]} -eq 0 ] ; then
    echo "At least <API_URL> is expected as argument"
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

echo "Starting saboteur scenario.."
start_time=$(date +%s.%N)
request_counter=0

for ((i=1; i<=100; i++)); do
    curl -s --retry 5 --retry-connrefused -X PUT "$API_URL/cars/saboteur" > /dev/null &
    ((request_counter++))
    if [ $request_counter -ge $PARALLEL_TASKS ]; then
        wait
        request_counter=0
    fi
done
wait

end_time=$(date +%s.%N)
echo "Scenario completed in $(echo "$end_time - $start_time" | bc) seconds"
