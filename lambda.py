import boto3
from botocore.exceptions import ClientError

ses_client = boto3.client('ses')

def send_email(subject, body, recipient_email):
    sender_email = 'nenaadel30@gmail.com'
    charset = 'UTF-8'

    try:
        response = ses_client.send_email(
            Destination={
                'ToAddresses': [recipient_email],
            },
            Message={
                'Body': {
                    'Text': {
                        'Charset': charset,
                        'Data': body,
                    },
                },
                'Subject': {
                    'Charset': charset,
                    'Data': subject,
                },
            },
            Source=sender_email,
        )
    except ClientError as e:
        print(e.response['Error']['Message'])
        return False
    else:
        print("Email sent! Message ID:", response['MessageId'])
        return True

def lambda_handler(event, context):
    subject = "State File Change Detected"
    body = "Changes have been detected in the state file. Please review."
    recipient_email = 'nenaadel30@gmail.com'
    send_email(subject, body, recipient_email)