import os
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb = boto3.resource('dynamodb')
table_name = os.environ.get('TABLE_NAME')
table = dynamodb.Table(table_name)

def lambda_delete_itens(event, context):
    list_pk = event.get("listPk")
    item_id = event.get("itemId")

    if not list_pk or not item_id:
        return response(False, "Missing required parameters: 'listPk' and/or 'itemId'")

    pk = f"LIST#{list_pk}"
    sk = f"ITEM#{item_id}"

    try:
        existing_item = table.get_item(Key={'PK': pk, 'SK': sk}).get("Item")

        if existing_item:
            table.delete_item(Key={'PK': pk, 'SK': sk})

        # Mesmo que não exista, retornamos sucesso
        return response(True, None)

    except Exception as e:
        logger.error(f"Error deleting item: {str(e)}")
        return response(False, f"Could not delete item: {str(e)}")

def response(success, error):
    result = {"success": success}
    if not success and error:
        result["error"] = error
    return result
