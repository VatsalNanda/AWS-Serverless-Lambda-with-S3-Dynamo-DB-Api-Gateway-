aws s3 mb s3://my-first-s3-bucket-test-vatsal

aws s3 cp notes.txt s3://my-first-s3-bucket-test-vatsal

aws s3 sync . s3://my-first-s3-bucket-test-vatsal

aws s3api put-bucket-policy --bucket my-first-s3-bucket-test-vatsal --policy file://policy.json