import json
import boto3
import os
from boto3.dynamodb.conditions import Key, Attr

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.getenv('TABLE_NAME', 'bakery-bank')
TABLE = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    
    try:

        # pega o ID do usuário do Cognito
        user_id = event['requestContext']['authorizer']['claims']['sub']

        # pega a data do query string (?date=YYYY-MM-DD)
        params = event.get('queryStringParameters') or {}
        date = params.get('date')

        key_condition = Key('PK').eq(f'USER#{user_id}') & Key('SK').begins_with('ITEM#')

        if date:
            response = TABLE.query(
                KeyConditionExpression=key_condition,
                FilterExpression=Attr('date').eq(date)
            )
        else:
            response = TABLE.query(
                KeyConditionExpression=key_condition
            )

        items = response.get('Items', [])
        
        return {
            'statusCode': 200,
            'headers': { 'Content-Type': 'application/json' },
            'body': json.dumps({
                'items': items,
                'count': len(items)
            })
        }
        
    except Exception as error:
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': str(error)})
        }