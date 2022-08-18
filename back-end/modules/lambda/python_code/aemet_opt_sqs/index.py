import http.client, json, boto3, os
from urllib.request import urlopen
from datetime import datetime, time


def send_message_sqs(message):
    response = boto3.client("sqs").send_message(
        QueueUrl=os.environ["QUEUE_URL"], MessageBody=json.dumps(message)
    )


def get_rain_prob(weather_data):
    today_prediction = {}
    daily_predictions = weather_data[0]["prediccion"]["dia"]
    today = datetime.combine(datetime.now(), time.min).strftime("%Y-%m-%dT%H:%M:%S")

    for d in daily_predictions:
        if d["fecha"] == today:
            today_prediction = d

    return today_prediction["probPrecipitacion"][0]["value"]


def build_message(prob):
    return {
        "umbrella": True if prob > int(os.environ["UMBRELLA_THRESHOLD"]) else False,
        "rain_prob": prob,
    }


def handle_origin(event):
    default_headers = {
        "Access-Control-Allow-Headers": "Content-Type",
        "Access-Control-Allow-Origin": "https://www.umbrella-project-albertopmp.com",
        "Vary": "Origin",
        "Access-Control-Allow-Methods": "OPTIONS,POST,GET",
    }

    if "headers" in event:
        origin = event["headers"]["origin"]
        if origin == "https://umbrella-project-albertopmp.com":
            default_headers["Access-Control-Allow-Origin"] = origin
        return default_headers
    else:
        return {}


def lambda_handler(event, context):
    if "pathParameters" in event:
        MNCP_CODE = event["pathParameters"]["mncp"]
    else:
        MNCP_CODE = "15078"

    conn = http.client.HTTPSConnection("opendata.aemet.es")
    headers = {"cache-control": "no-cache"}
    conn.request(
        "GET",
        "/opendata/api/prediccion/especifica/municipio/diaria/"
        + MNCP_CODE
        + "?api_key="
        + os.environ["API_KEY"],
        headers=headers,
    )
    response = conn.getresponse()

    if response.status == 200:
        response_data = json.loads(response.read())
        conn.close()
        response = urlopen(response_data["datos"])
        weather_data = json.loads(response.read().decode("latin-1"))

        rain_prob = get_rain_prob(weather_data)
        message = build_message(rain_prob)

        if "resources" in event:  # From EventBridge
            send_message_sqs(message)

        return {
            "statusCode": 200,
            "headers": handle_origin(event),
            "body": json.dumps(message),
        }
