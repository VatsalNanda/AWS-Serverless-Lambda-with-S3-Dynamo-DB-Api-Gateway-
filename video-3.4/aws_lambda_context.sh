zip function_code.zip index.js 


aws lambda create-function --function-name lambda-context-function \
--zip-file fileb://function_code.zip --handler index.handler --runtime nodejs20.x \
--role arn:aws:iam::604456545213:role/lambda_execution_role

aws lambda invoke --function-name lambda-context-function out --log-type Tail \
--query 'LogResult' --output text | base64 -D