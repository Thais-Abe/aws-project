import json
import os
import boto3
from botocore.exceptions import ClientError

dynamodb = boto3.resource('dynamodb')
table_name = os.getenv('TABLE_NAME', 'bakery-bank')  # Fallback
table = dynamodb.Table(table_name)

def lambda_add_to_list(event, context):
    try:
        # Extrai o corpo do evento (API Gateway ou chamada direta)
        body = json.loads(event['body']) if 'body' in event else event
        
        # Valida campos obrigatórios
        if not body.get('date') or not body.get('name'):
            return {
                'statusCode': 400,
                'body': json.dumps({'error': 'Missing required fields: date and name'})
            }
        
        date = body['date']
        name = body['name']
        
        # Monta o item conforme a estrutura da tabela
        item = {
            'PK': f'LIST#{date}',
            'SK': f'ITEM#{context.aws_request_id}',
            'name': name,
            'status': 'todo',
            'date': date  
        }
        
        # Insere no DynamoDB
        table.put_item(Item=item)
        
        return {
            'statusCode': 200,
            'body': json.dumps({'success': True, 'item': item})
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': json.dumps({'error': str(e)})
        }