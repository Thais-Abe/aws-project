import json
import boto3
import os
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.getenv('TABLE_NAME', 'bakery-bank')
TABLE = dynamodb.Table(TABLE_NAME)

def lambda_handler(event, context):
    
    try:
        # pega o ID do usuário do Cognito
        user_id = event['requestContext']['authorizer']['jwt']['claims']['sub']
        
        # busca itens no Dynamo
        items = TABLE.query(
            KeyConditionExpression=Key('PK').eq(f'USER#{user_id}') & Key('SK').begins_with('ITEM#')
        ).get('Items', [])
        
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