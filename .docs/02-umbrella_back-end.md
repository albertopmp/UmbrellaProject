## *Umbre??a Back-end*

5 - Then I needed to create a LambdaFunction for the backend. I chose to integrate it with API Gateaway, so I could make requests from the frontend ->  Because it's a proxy integration, you can change the Lambda function implementation at any time without needing to redeploy your API.
	(https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-create-api-as-simple-proxy-for-lambda.html)
	-> This LambdaFunction calls the AEMET API
	-> In addtion, I wanted to use my custom domain name for the API, instead of the endpoint https://9jf2w8har7.execute-api.eu-west-1.amazonaws.com/test/umbrella/{mncp}
		:: https://www.readysetcloud.io/blog/allen.helton/adding-a-custom-domain-to-aws-api-gateway/
		(I used a TYPE A record instead of CNAME)
		(Remember to change mapped stage from the API Gateaway)

	-> Finally, I could call https://api.umbrella-project-albertopmp.com/umbrella/{mncp} and get back {"umbre??a": false}


6 -  Next I needed to implement a Periodic call to the aforementioned LambdaFunction and publish to an SNS topic

	6.1 -  First I configured EventBridge to emit a periodic event (using a cron task) at 4am GMT, as I want Umbre??a to send notifications al 6am Madrid (GMT +2). The event is emitted to a LambdaFunction
	https://docs.aws.amazon.com/AmazonCloudWatch/latest/events/RunLambdaSchedule.html

	6.2 -  Then I had to tweak the UmbrellaAEMET_SQS to change its behaviour depending on the trigger
		  ** API Gateawsay -> Attack AEMET API
		
	 	  ** EventBridge -> Attack AEMET API + Call Umbrella_SQS_To_SNS in order to publish to SNS
			As calling a Lambda from another is an anti-pattern (https://docs.aws.amazon.com/lambda/latest/operatorguide/functions-calling-functions.html), I opted to create an SQS queue which became the trigger of the function

			USE PRINCIPLE OF LEAST PRIVILEGE!! (UmbrellaAEMET_SQS_Role)
				sqs:SendMessage

	6.3 - Create Umbrella_SQS_To_SNS so that it is triggered by new publications in SQS PeriodicUmbrellaQueue and send notifications to sns PeriodicUmbrellaNotifications
		USE PRINCIPLE OF LEAST PRIVILEGE!! (Umbrella_SQS_To_SNS_Role)
			sqs:ReceiveMessage
			sqs:DeleteMessage
			sqs:GetQueueAttributes
				sns:SendMessage


		I STRUGGLED WITH SQS PUBLICATIONS BUT I SOLVED IT BY CHECKING THE LOGS IN CLOUDWATCH!

		SQS AS LAMBDA TRIGGER: !!!!
		Lambda polls the queue and invokes your Lambda function synchronously with an event that contains queue messages. Lambda reads messages in batches and invokes your function once for each batch. When your function successfully processes a batch, Lambda deletes its messages from the queue. The following example shows an event for a batch of two messages.



Finally:

![Architecture Diagram](https://github.com/albertopmp/UmbrellaProject/blob/master/front-end/src/assets/img/about-img/architecture.png)