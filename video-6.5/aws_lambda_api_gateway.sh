API_ID=$(aws apigateway create-rest-api --name 'Ryder API' | jq -r .id)

AUTHORIZER_ID=$(aws apigateway create-authorizer \
  --rest-api-id $API_ID \
  --name "Ryder_Authorizer" \
  --type "COGNITO_USER_POOLS" \
  --provider-arns "arn:aws:cognito-idp:ap-south-1:604456545213:userpool/ap-south-1_BlatB5aeP" \
  --identity-source "method.request.header.Authorization" | jq -r .id)


API_ROOT_RESOURCE_ID=$(aws apigateway get-resources --rest-api-id $API_ID | jq -r '.items[].id')

RIDE_RESOURCE_ID=$(aws apigateway create-resource --rest-api-id $API_ID --parent-id $API_ROOT_RESOURCE_ID --path-part ride | jq -r .id)

ROLE_NAME=$(aws iam create-role --role-name APIGWLambdaRole --assume-role-policy-document file://trust_policy_api_gateway.json | jq -r .Role.RoleName)

POLICY_ARN=$(aws iam create-policy --policy-name LambdaPolicy --policy-document file://api_gateway_policy.json | jq -r .Policy.Arn)

aws iam attach-role-policy --policy-arn $POLICY_ARN --role-name $ROLE_NAME

aws apigateway put-method --rest-api-id $API_ID --resource-id $RIDE_RESOURCE_ID --http-method POST --authorization-type "COGNITO_USER_POOLS" --authorizer-id $AUTHORIZER_ID

aws apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $RIDE_RESOURCE_ID \
  --http-method POST \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:ap-south-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-south-1:604456545213:function:RequestRide/invocations \
  --credentials arn:aws:iam::604456545213:role/$ROLE_NAME

aws apigateway create-deployment --rest-api-id $API_ID --stage-name test
