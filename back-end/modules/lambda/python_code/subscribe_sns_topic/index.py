import json, boto3, os


def handle_origin(origin):
    allowedOrigin = "https://www.umbrella-project-albertopmp.com"
    if origin == "https://umbrella-project-albertopmp.com":
        allowedOrigin = origin

    return allowedOrigin


def lambda_handler(event, context):
    response = boto3.client("sns").subscribe(
        TopicArn=os.environ["TOPIC_ARN"], Protocol="email", Endpoint=event["body"]
    )

    return {
        "statusCode": 200,
        "headers": {
            "Access-Control-Allow-Headers": "Content-Type",
            "Access-Control-Allow-Origin": handle_origin(event["headers"]["origin"]),
            "Vary": "Origin",
            "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
        },
        "body": json.dumps(response),
    }
