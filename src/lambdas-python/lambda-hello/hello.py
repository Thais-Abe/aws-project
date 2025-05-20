import json

def lambda_hello(event, context):
    return {
        "statusCode":200,
        "body": json.dumps({'success': 'Hello, Terraform!'})
    }



