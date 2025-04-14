API_ID=$(aws apigateway create-rest-api --name 'Pet Store API' | jq -r .id)

# Get root resource ID (only the one with null pathPart)
API_ROOT_RESOURCE_ID=$(aws apigateway get-resources --rest-api-id $API_ID \
  | jq -r '.items[] | select(.pathPart == null) | .id')

# Create /pets under root
PROXY_RESOURCE_ID=$(aws apigateway create-resource \
  --rest-api-id $API_ID \
  --parent-id $API_ROOT_RESOURCE_ID \
  --path-part pets \
  | jq -r .id)

# Create /pets/{petId} under /pets
PROXY_ID_RESOURCE_ID=$(aws apigateway create-resource \
  --rest-api-id $API_ID \
  --parent-id $PROXY_RESOURCE_ID \
  --path-part "{petId}" \
  | jq -r .id)

aws apigateway put-method --rest-api-id $API_ID --resource-id $PROXY_RESOURCE_ID --http-method GET --authorization-type "NONE"

aws apigateway put-method --rest-api-id $API_ID --resource-id $PROXY_ID_RESOURCE_ID --http-method GET --authorization-type "NONE" --request-parameters method.request.path.petId=true

aws apigateway put-method-response --rest-api-id $API_ID --resource-id $PROXY_RESOURCE_ID --http-method GET --status-code 200 

aws apigateway put-method-response --rest-api-id $API_ID --resource-id $PROXY_ID_RESOURCE_ID --http-method GET --status-code 200 

aws apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $PROXY_RESOURCE_ID \
  --http-method GET \
  --type HTTP \
  --integration-http-method GET \
  --uri "https://your-backend-url.com/pets"

aws apigateway put-integration \
  --rest-api-id $API_ID \
  --resource-id $PROXY_ID_RESOURCE_ID \
  --http-method GET \
  --type HTTP \
  --integration-http-method GET \
  --uri "https://your-backend-url.com/pets/{id}" \
  --request-parameters "integration.request.path.id=method.request.path.petId"

aws apigateway put-integration-response \
  --rest-api-id $API_ID \
  --resource-id $PROXY_RESOURCE_ID \
  --http-method GET \
  --status-code 200 \
  --selection-pattern "" \
  --response-templates '{"application/json": ""}'


aws apigateway put-integration-response \
  --rest-api-id $API_ID \
  --resource-id $PROXY_ID_RESOURCE_ID \
  --http-method GET \
  --status-code 200 \
  --selection-pattern "" \
  --response-templates '{"application/json": ""}'

aws apigateway create-deployment --rest-api-id $API_ID --stage-name test



