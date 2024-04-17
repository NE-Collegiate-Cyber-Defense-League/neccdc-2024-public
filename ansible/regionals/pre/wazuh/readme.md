

Manually run. Had to run in an Ubuntu container had issue on OSX
```bash
docker run --name ubuntu --rm -it -v "$(pwd)"/indexer/certificates/:/cert ubuntu bash

apt update && apt install -y openssl

bash /cert/wazuh-certs-tool.sh -A
```
