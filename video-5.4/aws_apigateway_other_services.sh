TOPIC_ARN=$(aws sns create-topic --name lambda-proxy-topic --output text --query 'TopicArn')

aws sns subscribe --topic-arn $TOPIC_ARN --protocol sms --notification-endpoint 9898989898

aws sns publish --topic-arn $TOPIC_ARN --message 'This is a test'


PROXY_RESOURCE_ID=$(aws apigateway create-resource \
  --rest-api-id $API_ID \
  --parent-id $API_ROOT_RESOURCE_ID \
  --output text \
  --query 'id'

aws apigateway put-method --rest-api-id $API_ID --resource-id $PROXY_RESOURCE_ID --http-method  POST --authorization-type "NONE"

aws iam create-role --role-name lambda_proxy_role --assume-role-policy-document file://trust_policy.json --output text --query 'Role.Arn'

aws iam put-role-policy \
    --role-name lambda_proxy_role \
    --policy-name 'sns-publish' \
    --policy-document '{
        "Version": "2012-10-17",
        "Statement":{
            "Effect":"Allow",
            "Action":"sns:Publish",
            "Resource":"'$TOPIC_ARN'"
        }
    }'


LAMBDA_PROXY_ROLE_ARN=$(aws iam get-role --role-name lambda_proxy_role --query 'Role.Arn' --output text)


aws apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $PROXY_RESOURCE_ID \
  --http-method POST \
  --type AWS \
  --integration-http-method POST \
  --uri arn:aws:apigateway:ap-south-1:sns:action/Publish \
  --credentials $LAMBDA_PROXY_ROLE_ARN \
  --request-templates file://sns-request-template.json \
  --passthrough-behavior NEVER

aws apigateway put-method-response \
  --rest-api-id $API_ID \
  --resource-id $PROXY_RESOURCE_ID \
  --http-method POST \
  --status-code 200

aws apigateway put-integration-response \
  --rest-api-id $API_ID \
  --resource-id $PROXY_RESOURCE_ID \
  --http-method POST \
  --status-code 200 \
  --selection-pattern ""

aws apigateway create-deployment \
  --rest-api-id $API_ID \
  --stage-name test









