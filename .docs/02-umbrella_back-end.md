
## *Umbre??a* back-end

Once the Angular WebApp could be accessed from the Internet with my custom domain name, it was time to implement the back-end functionality:

1. I decided that the best way to communicate front-end and back-end was through an API Gateway, which would be integrated with Lambda functions. One of the biggest advantages of this architecture is that it's possible to change the Lambda function implementarion without needing to redeploy the API ([AWS Documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.html))

2.  I also wanted to use my custom domain name for the API, instead of the provided by AWS (something like `https://9jf2w8har7.execute-api.eu-west-1.amazonaws.com/test/*`). In order to do that I had to:
	- Create a new certificate for the subdomain `api.umbrella-project-albertopmp.com` and validate it through Route53
	- Configure the API Gateway custom domain through the management console
	- Create API Mapping to point the custom domain to an existing API Gateway Stage
	- Create a **new Type A record in the Route53 Hosted Zone for the domain that routes requests to `api.umbrella-project-albertopmp.com` directly to the API Gateway** ([Tutorial](https://www.readysetcloud.io/blog/allen.helton/adding-a-custom-domain-to-aws-api-gateway/))

3.  Afterwards, I needed to define the endpoints of the API Gateway. Following the requirements that were defined during the definition of the project, three endpoints were created:
	- **GET /umbrella/{mncp}** &rarr; Returns `true` or `false`  depending on whether it's going to rain or not in the specified {`mncp`} (Identifier of each spanish town according to [INE classification](https://www.ine.es/daco/daco42/codmun/codmunmapa.htm))
	- **GET /subscribers/count** &rarr; Returns the number of *Umbre??a* subscribers
	- **POST /subscribers/{mail}** &rarr; Allows users to subscribe to *Umbre??a* in order to receive daily reminders in their emails

4. Each one of this endpoints invokes a different Lambda function written in Python:
	- **/umbrella/{mncp}** &rarr; **UmbrellaAEMET_OPT_SQS**: Attacks *AEMET API* (Spain National Weather Service), gets the rain probability and returns `true` or `false` depending on whether the `rain_prob` is over a predefined threshold. It also returns the `rain_prob`.
	-  **/subscribers/count** &rarr; **UmbrellaCountSNSTopicSubs**: Uses the AWS SDK for Python (Boto3) to get how many subscribers there are in a SNS Topic
	- **/subscribers/{mail}** &rarr; **UmbrellaSubscribeSNSTopic**: Uses the AWS SDK for Python (Boto3) to add a subscribers to an SNS Topic

> **All Lambda functions are configured using the principle of least privilige:**

| Lambda Function| Permissions |
|--|--|
| UmbrellaAEMET_OPT_SQS | sqs:SendMessage |
| UmbrellaCountSNSTopicSubs | sns:GetTopicAttributes|
| UmbrellaSubscribeSNSTopic| sns:Subscribe |
| UmbrellaSQS_TO_SNS \*|  sqs:ReceiveMessage, sqs:DeleteMessage, sqs:GetQueueAttributes, sns:Publish|

> **All Lambda functions have permission to create CloudWatch Logs:** logs:CreateLogGroup, logs:CreateLogStream, logs:PutLogEvents
---

5. As it has already been mentioned, there is an **SNS Topic whose mission is to deliver daily reminders to its subscribers.** This might not be the most elegant implementation, but for this first iteration I wanted to try SNS. In a future iteration SES could be used to replace the SNS

6. Then I had to fulfill another one of my self-established requirements: **daily reminders from *Umbre??a***. I created an **EventBridge Rule that triggers  UmbrellaAEMET_OPT_SQS Lambda Function at 04:30 UTC (06:30 UTC+2 - Madrid)**  &rarr; `cron(30 4 * * ? 2022)` ([AWS Documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/RunLambdaSchedule.html))
As you may have already noticed, this Lambda Function is also triggered by the API Gateway (`re-use code`). The difference is that **it sends a message to an SQS queue (with the same information we discussed before) only when it's triggered by the EnvetBridge Rule**, that's why the *_OPT_SQS*

7. The aforementioned **SQS is the solution for a common lambda anti-pattern** ([AWS Documentation](https://docs.aws.amazon.com/lambda/latest/operatorguide/functions-calling-functions.html)) , as **it allows two Lambda Functions to communicate without being tightly coupled** &rarr; *"The queue durably persists messages and decouples the two functions."*
So the flow is the following:
> **EventBridge Rule &rarr; UmbrellaAEMET_OPT_SQS &rarr; SQS &rarr; UmbrellaSQS_TO_SNS &rarr;  SNS &rarr;  Subscribers**

8. The last Lambda **UmbrellaSQS_TO_SNS is triggered when a new message is received by the SQS queue. It takes the message from the queue (deletes it) and publishes a custom message to an SNS Topic**, which then notifies all subscribers

9. During the development of *Umbre??a* I also used other services like:
	- **Budgets** to create an *always-free-budget*. This is a monthly budget with a \$2 amount and an 80% threshold (\$1.60). Once the threshold is , it sends a notification to my email
	- **CloudWatch** was indispensable, as it allowed my to fix many bugs by checking its logs
	- **IAM** to manage users, roles, policies...

Finally, all the above can be summarized with the following architecture diagram:
![Architecture Diagram](https://github.com/albertopmp/UmbrellaProject/blob/master/front-end/src/assets/img/about-img/architecture.png)

> Please check out `03-terraform.md` if you want to know how I migrated  my whole infrastructure to IaC with Terraform :)