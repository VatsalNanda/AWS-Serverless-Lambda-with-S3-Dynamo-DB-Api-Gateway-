zip function_code.zip index.js 

aws lambda create-function --function-name lambda-event-function \
--zip-file fileb://function_code.zip --handler index.handler --runtime nodejs20.x \
--role arn:aws:iam::604456545213:role/lambda_execution_role

aws lambda invoke \
--function-name lambda-event-function \
--invocation-type Event \
--payload file://event.json \
--cli-binary-format raw-in-base64-out \
response.json