#!/usr/bin/env bash
#
# docker wrapper script
# Detects potentially destructive or unintended docker compose commands

DOCKER_BIN="/usr/bin/docker"

# Join arguments for easier pattern matching
ARGS=("$@")
CMD="${ARGS[*]}"

# Function to show an error and exit
warn_and_exit() {
    echo "⚠️  WARNING: You are attempting to run a potentially dangerous Docker command:"
    echo "    docker $CMD"
    echo
    echo "Reason: $1"
    echo
    echo "Aborting execution."
    exit 1
}

# Detect risky patterns
if [[ "${ARGS[0]}" == "compose" ]]; then
    case "${ARGS[1]}" in
        down)
            # "docker compose down" with no additional args
            if [[ "${#ARGS[@]}" -eq 2 ]]; then
                warn_and_exit "'docker compose down' without arguments will bring down the entire stack."
            fi
            ;;
        restart)
            # "docker compose restart" with no args
            if [[ "${#ARGS[@]}" -eq 2 ]]; then
                warn_and_exit "'docker compose restart' without arguments restarts all services."
            fi
            ;;
        up)
            # "docker compose up" without -d flag
            if [[ ! " ${ARGS[*]} " =~ " -d" ]]; then
                warn_and_exit "'docker compose up' without '-d' runs in the foreground."
            fi
            ;;
    esac
fi

# Safe to run
exec "$DOCKER_BIN" "$@"
