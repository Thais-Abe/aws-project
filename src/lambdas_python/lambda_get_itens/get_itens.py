import json
import boto3
import os
from boto3.dynamodb.conditions import Key

dynamodb = boto3.resource('dynamodb')
TABLE_NAME = os.getenv('TABLE_NAME', 'bakery-bank')
TABLE = dynamodb.Table(TABLE_NAME)

def lambda_get_itens(event, context):
    
    try:

        # pega a data do query string (?date=YYYY-MM-DD)
        params = event.get('queryStringParameters') or {}
        date = params.get('date')

        if not date:
            return {
                'statusCode': 400,
                'headers': {'Content-Type': 'application/json'},
                'body': json.dumps({'error': 'date parameter is required'})
            }
    
        response = TABLE.query(
            KeyConditionExpression=Key('PK').eq(f'LIST#{date}') & Key('SK').begins_with('ITEM#')
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
        print(f"Erro Lambda: {error}")
        return {
            'statusCode': 500,
            'headers': {'Content-Type': 'application/json'},
            'body': json.dumps({'error': str(error)})
        }