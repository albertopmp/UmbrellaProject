import json, boto3, os


def lambda_handler(event, context):
    mail_content = ""
    message = json.loads(event["Records"][0]["body"])

    if message["umbrella"]:
        mail_content = "Don't forget your umbrella, you'll need it!"
    else:
        mail_content = "The weather is going to be nice, enjoy it!"

    mail_content += "\nDon't forget to check out www.umbrella-project-albertopmp.com"

    response = boto3.client("sns").publish(
        TopicArn=os.environ["TOPIC_ARN"], Subject="Umbre??a", Message=mail_content
    )

    return {"statusCode": 200, "body": json.dumps(response)}
