export TEST_MINIO_URL=127.0.0.1
export MINIO_ADDRESS_PORT=9000
export MINIO_CONSOLE_ADDRESS_PORT=9001
export TEST_MINIO_ADDRESS=$TEST_MINIO_URL:$MINIO_ADDRESS_PORT
export TEST_MINIO_CONSOLE_ADDRESS=$TEST_MINIO_URL:$MINIO_CONSOLE_ADDRESS_PORT
export TEST_MINIO_ACCESS_KEY=minioaccesskey
export TEST_MINIO_SECRET_KEY=miniosecretkey

docker run -d \
    -p $TEST_MINIO_ADDRESS:$MINIO_ADDRESS_PORT \
    -p $TEST_MINIO_CONSOLE_ADDRESS:$MINIO_CONSOLE_ADDRESS_PORT \
    -e MINIO_ROOT_USER=$TEST_MINIO_ACCESS_KEY \
    -e MINIO_ROOT_PASSWORD=$TEST_MINIO_SECRET_KEY \
    --entrypoint /bin/bash \
    minio/minio:latest -c "minio server /data --console-address :$MINIO_CONSOLE_ADDRESS_PORT --address :$MINIO_ADDRESS_PORT"

python3 -c "import os; from minio import Minio; Minio(endpoint=os.environ.get('TEST_MINIO_ADDRESS'),access_key=os.environ.get('TEST_MINIO_ACCESS_KEY'),secret_key=os.environ.get('TEST_MINIO_SECRET_KEY'),secure=False); print('MINIO OK!')"
