aws iam create-role --role-name lambda_execution_role --assume-role-policy-document file://trust_policy.json

aws iam attach-role-policy --role-name lambda_execution_role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

zip function_code.zip index.js

aws lambda create-function --function-name my_first_lambda_function \
--zip-file fileb://function_code.zip --handler index.handler --runtime nodejs20.x \
--role arn:aws:iam::604456545213:role/lambda_execution_role

aws lambda invoke --function-name my_first_lambda_function out --log-type Tail \
--query 'LogResult' --output text | base64 -D
