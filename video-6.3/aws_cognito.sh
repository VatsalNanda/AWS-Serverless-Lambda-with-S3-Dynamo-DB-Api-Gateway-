POOL_ID=$(aws cognito-idp create-user-pool --pool-name RyderPool | jq -r .UserPool.Id)

aws cognito-idp create-user-pool-client --user-pool-id $POOL_ID --client-name RyderWebApp --no-generate-secret

