# sam-with-mysql

AWS SAM Ruby runtime with MySQL.

## Required tools

* AWS CLI
* AWS SAM CLI
* S3 bucket. e.g. `s3://s3_bucket_for_sam_app`

## Environment variables

```sh
export AWS_DEFAULT_REGION=ap-northeast-1
export AWS_ACCESS_KEY_ID=...
export AWS_SECRET_ACCESS_KEY=...
export S3_BUCKET=... # e.g. S3_BUCKET=s3_bucket_for_sam_app
```

## Build Docker image for `bundle install`

```sh
cd lambda-ruby-bundle
docker build -t lambda-ruby-bundle:ruby2.5 .
```

## Setup

```sh
bundle install
bundle exec rake sam:bundle-libs
bundle exec rake sam:bundle

cp template.yaml.sample template.yaml
vi template.yaml # Fix MYSQL_HOSR

```
## Invoke Lambda locally

```sh
docker-compose up -d
bundle exec rake sam:local:invoke
open http://localhost:5601
```

## Deploy

```sh
bundle exec rake sam:deploy
```

## Invoke Lambda remotely

```sh
# tail -f function log
sam logs -n sam-with-mysql
```

```sh
bundle exec rake sam:invoke
```

## Delete SAM

```sh
aws cloudformation delete-stack --stack-name sam-with-mysql
```
