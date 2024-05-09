#!/bin/bash

usage () {
    echo "Usage: $0 [<OPTIONS>] <API_URL> [<car_count>]"
    echo ""
    echo "Inserts the given amount of cars by repeatedly calling POST <API_URL>/cars with random car data"
    echo "<car_count> defaults to 500"
    echo ""
    echo -e "-p|--parallel <task_count>\tThe number of concurrent tasks to use. (Default: 100)"
    echo ""
    echo "OPTIONS:"
    echo -e "-h|--help\t\t\tShow this help"
}

PARALLEL_TASKS=100
CAR_COUNT=500

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
if [ ${#POSITIONAL[@]} -eq 2 ] ; then
    CAR_COUNT="${POSITIONAL[1]}"
fi

random_color() {
    local -a colors=("red" "blue" "green" "yellow" "black" "white" "orange" "purple" "pink" "cyan")
    echo ${colors[RANDOM % ${#colors[@]}]}
}

generate_car_data() {
    cat <<EOF
{
    "color": "$(random_color)",
    "weight": $((1000 + RANDOM % 1000)),
    "engineDisplacement": $((RANDOM % 10)).$((RANDOM % 10)),
    "horsepower": $((100 + RANDOM % 200)),
    "torque": $((100 + RANDOM % 200))
}
EOF
}

echo "Inserting $CAR_COUNT cars to $API_URL using $PARALLEL_TASKS parallel tasks"
start_time=$(date +%s.%N)
seq $CAR_COUNT | xargs -I{} -P$PARALLEL_TASKS sh -c "$(declare -f generate_car_data random_color); curl -s --retry 5 --retry-connrefused -XPOST -H 'Content-Type: application/json' -d \"\$(generate_car_data)\" \"$API_URL/cars\"" > /dev/null
end_time=$(date +%s.%N)
echo "Inserted $CAR_COUNT cars in $(echo "$end_time - $start_time" | bc) seconds"
