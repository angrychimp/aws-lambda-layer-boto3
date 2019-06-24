# Lambda Layer Builder: boto3
This project provides a rough framework for automating the AWS Lambda layer build process.

## Requirements
This project requires
* AWS Account with an S3 bucket for temporary ZIP storage
* [AWS CLI](https://aws.amazon.com/cli/) (with access keys configured for your AWS account)
* [Docker](https://docker.com)
* Python >= 2.7,3.5

## How-To
1. After cloning the repo, copy the `vars.txt.example` file to `vars.txt`
2. Edit `vars.txt` to provide an S3 bucket name
3. Optionally provide a custom layer name
4. Optionally provide a `boto3` version (otherwise current stable version will be used)
5. Run `make` then `make publish`
6. Verify that your new Lambda layer is available via the console, or by running `aws lambda list-layers`