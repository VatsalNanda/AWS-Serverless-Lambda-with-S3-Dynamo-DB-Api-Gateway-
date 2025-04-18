aws dynamodb create-table --table-name Ryder --attribute-definitions AttributeName=RideId,AttributeType=S --key-schema AttributeName=RideId,KeyType=HASH --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

ROLE_NAME=$(aws iam create-role --role-name RyderLmbda --assume-role-policy-document file://trust_policy.json | jq -r .Role.RoleName)


aws iam attach-role-policy --role-name $ROLE_NAME --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

POLICY_ARN=$(aws iam create-policy --policy-name DynamoDBWriteAccess --policy-document file://ddb_write_policy.json | jq -r .Policy.Arn)

aws iam attach-role-policy --policy-arn $POLICY_ARN --role-name $ROLE_NAME


zip function_code.zip index.js 

aws lambda create-function --function-name RequestRide \
--zip-file fileb://function_code.zip --handler index.handler --runtime nodejs20.x \
--role arn:aws:iam::604456545213:role/RyderLmbda