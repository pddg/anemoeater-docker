#!/usr/env bash

DEFAULT_USER=anemometer
DEFAULT_PASS=""
DEFAULT_CELL=5
DEFAULT_PORT=3306
DEFAULT_LOG_DIR=/logs/

if [[ -z "${ANEMOMETER_DB_HOST}" ]]; then
    echo "ANEMOMETER_DB_HOST must be defined."
    exit 1
fi

if [[ -z "${ANEMOMETER_DB_USER}" ]]; then
    echo "ANEMOMETER_DB_USER is not defined use default value ('${DEFAULT_USER}')"
    ANEMOMETER_DB_USER=${DEFAULT_USER}
fi

if [[ -z "${ANEMOMETER_DB_PORT}" ]]; then
    ANEMOMETER_DB_PORT=${DEFAULT_PORT}
fi

if [[ -z "${ANEMOMETER_DB_PASS}" ]]; then
    ANEMOMETER_DB_PASS=${DEFAULT_PASS}
fi

if [[ -z "${ANEMOMETER_CELL}" ]]; then
    ANEMOMETER_CELL=${DEFAULT_CELL}
fi

if [[ -z "${ANEMOMETER_LOG_DIR}" ]]; then
    ANEMOMETER_LOG_DIR=${DEFAULT_LOG_DIR}
fi

find ${ANEMOMETER_LOG_DIR}* -name "*.log" -type f | xargs echo
echo "Try to post log data to ${ANEMOMETER_DB_USER}:${ANEMOMETER_DB_PASS}@${ANEMOMETER_DB_HOST}:${ANEMOMETER_DB_PORT}"
find ${ANEMOMETER_LOG_DIR}* -name "*.log" -type f \
    | xargs /anemoeater/anemoeater \
        --no-docker \
        --host=${ANEMOMETER_DB_HOST} \
        --user=${ANEMOMETER_DB_USER} \
        --port=${ANEMOMETER_DB_PORT} \
        --password=${ANEMOMETER_DB_PASS} \
        --cell=${ANEMOMETER_CELL}

if [[ $? -eq 0 ]]; then
    echo "Done"
    exit 0
else
    echo "Failed"
    exit 1
fi

