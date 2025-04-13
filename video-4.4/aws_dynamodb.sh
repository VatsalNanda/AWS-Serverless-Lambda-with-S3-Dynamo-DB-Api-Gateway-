aws dynamodb create-table \
  --table-name Book \
  --attribute-definitions AttributeName=Author,AttributeType=S AttributeName=BookName,AttributeType=S \
  --key-schema AttributeName=Author,KeyType=HASH AttributeName=BookName,KeyType=RANGE \
  --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1

aws dynamodb put-item \
  --table-name Book \
  --item '{"Author":{"S":"Anonymous"},"BookName":{"S":"Unforgiven"},"ReleaseYear":{"S":"1990"}}' \
  --return-consumed-capacity TOTAL


aws dynamodb put-item \
  --table-name Book \
  --item '{"Author":{"S":"Jeff Kiney"},"BookName":{"S":"Diary of a Wimpy Kid"},"ReleaseYear":{"S":"2014"}}' \
  --return-consumed-capacity TOTAL

aws dynamodb query \
    --table-name Book \
    --projection-expression "BookName" \
    --key-condition-expression "Author = :v1" \
    --expression-attribute-values file://expression_attributes.json \
    --return-consumed-capacity TOTAL