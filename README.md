# Wordpress Enablement

## Setup

1. brew install pipx awscli
2. pipx ensurepath
3. pipx install awsume
4. Set up aws cli credentials and config files
5. awsume [iam-user-name] (in my case, awsume tom)
6. Done! Test with aws s3 ls

## Doing stuff

1. terraform init
2. terraform plan
3. terraform apply