# Automated ECS deployment with standard rollout strategy

This deployment does not require CodeDeploy because it uses ECS Controller for deploying updates.

## Prerequisites

1.  Amazon ECS resources with ECS as the deployment controller.
2.  Application image is tagged and stored in an image repository.
3.  CodeBuild resources to build image and store in private ECR.
4.  CodeDeploy resources.
5.  A `buildspec.yaml` file for CodeBuild.


## Procedures

1.  Create a pipeline in CodePipeline that deploys container application on ECS using a standard deployment.
2.  The pipeline detect changes on application source code
3.  CodePipeline uses CodeBuild to build new image version and push to Amazon ECR
4.  The pipeline includes a `Manual Approval` process for reviewing changes.
5.  CodePipeline uses CodeDeploy to create a new version of ECS application.


The buildspec.yaml file should look like:

```yaml
version: 0.2

phases:
  pre_build: # Optional phase that is used to run commands before building the application code
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - ACCOUNT_ID=$(echo $CODEBUILD_BUILD_ARN | cut -f5 -d ':') && echo "The Account ID is $ACCOUNT_ID"
      - echo "The AWS Region is $AWS_DEFAULT_REGION"
      - REPOSITORY_URI=$ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/application
      - echo "The Repository URI is $REPOSITORY_URI"
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $REPOSITORY_URI
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=$COMMIT_HASH
  build:
    on-failure: ABORT
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $REPOSITORY_URI:$IMAGE_TAG ./build/
      - docker tag $REPOSITORY_URI:$IMAGE_TAG $REPOSITORY_URI:$IMAGE_TAG
      - echo Image built with name $REPOSITORY_URI:$IMAGE_TAG
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker image...
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - echo Writing image definitions file...
      - printf '[{"name":"container_name_here","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json
      - printf '{"ImageURI":"%s"}' $REPOSITORY_URI:$IMAGE_TAG > imageDetail.json
artifacts: # Specifies that the appspec.yaml and taskdef.json files uploaded to your CodeCommit repository be included as build outputs. Without these files, your deployment fails.
  files:
    - imagedefinitions.json
    - imageDetail.json
    - appspec.yaml
    - taskdef.json
```

## References

1.  [Amazon ECS and CodeDeploy](https://docs.aws.amazon.com/codepipeline/latest/userguide/action-reference-ECS.html) - Deployment configuration option for CodePipeline.
2.  [Tutorial: Amazon ECS Standard Deployment with CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/ecs-cd-pipeline.html) - Official AWS tutorial for creating a CodePipeline pipeline that performs standard ECS deployment.
3.  [IAM for AWS CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/security-iam.html) - Setup and control AWS CodePipeline permissions.
4.  [Image definition file for standard deployment](https://docs.aws.amazon.com/codepipeline/latest/userguide/file-reference.html#pipelines-create-image-definitions) - Standard deployment uses `imagedefinitions.json` file

&nbsp;
