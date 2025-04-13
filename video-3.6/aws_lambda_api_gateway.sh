zip function_code.zip index.js 


aws lambda create-function --function-name lambda-api-gateway-function \
--zip-file fileb://function_code.zip --handler index.handler --runtime nodejs20.x \
--role arn:aws:iam::604456545213:role/lambda_execution_role

ROLE_NAME=$(aws iam create-role --role-name apigAwsProxyRole --assume-role-policy-document file://trust_policy_api_gateway.json | jq -r .Role.RoleName)

POLICY_ARN=$(aws iam create-policy --policy-name my-policy --policy-document file://api_gateway_policy.json  | jq -r .Policy.Arn)

aws iam attach-role-policy --policy-arn $POLICY_ARN --role-name $ROLE_NAME

API_ID=$(aws apigateway create-rest-api --name 'HelloWorld API' | jq -r .id)

API_ROOT_RESOURCE_ID=$(aws apigateway get-resources --rest-api-id $API_ID | jq -r '.items[].id')

PROXY_RESOURCE_ID=$(aws apigateway create-resource --rest-api-id $API_ID --parent-id $API_ROOT_RESOURCE_ID --path-part {proxy+} | jq -r .id)

aws apigateway put-method --rest-api-id $API_ID --resource-id $PROXY_RESOURCE_ID --http-method ANY --authorization-type "NONE"

aws apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $PROXY_RESOURCE_ID \
  --http-method ANY \
  --type AWS_PROXY \
  --integration-http-method POST \
  --uri arn:aws:apigateway:ap-south-1:lambda:path/2015-03-31/functions/arn:aws:lambda:ap-south-1:604456545213:function:lambda-api-gateway-function/invocations \
  --credentials arn:aws:iam::604456545213:role/$ROLE_NAME


aws lambda get-function --function-name lambda-api-gateway-function \
  --query 'Configuration.FunctionArn' --output text

aws apigateway create-deployment --rest-api-id $API_ID --stage-name test
