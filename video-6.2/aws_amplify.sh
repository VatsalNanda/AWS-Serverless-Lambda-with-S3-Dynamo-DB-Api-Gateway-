aws codecommit create-repository --repository-name rider-site --repository-description "Rider Source Code"

aws iam create-service-specific-credential --user-name deployment --service-name codecommit.amazonaws.com
