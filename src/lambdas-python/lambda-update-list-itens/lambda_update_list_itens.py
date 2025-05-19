import os
import boto3

def lambda_handler(event, context):
    dynamodb = boto3.resource('dynamodb')
    table_name = os.environ.get('TABLE_NAME')
    table = dynamodb.Table(table_name)

    list_pk = event.get('listPk') # data atual
    item_id = event.get('itemId')
    updates = event.get('updates')

    if not list_pk or not item_id or not updates:
        return response(False, "Missing required parameters: 'listPk', 'itemId' and/or 'updates'", None)

    new_name = updates.get('name')
    new_date = updates.get('date')
    new_status = updates.get('status')

    current_pk = f"LIST#{list_pk}"
    sk = f"ITEM#{item_id}"

    try:
        existing_item = table.get_item(
            Key={'PK': current_pk, 'SK': sk}
        ).get('Item')

        if not existing_item:
            return response(False, "Item not found", None)

        # Se a data mudou, copia para nova PK e deleta o antigo
        date_changed = new_date is not None and new_date != list_pk
        if date_changed:
            new_pk = f"LIST#{new_date}"

            # Criar novo item com os dados atualizados
            new_item_data = {
                'PK': new_pk,
                'SK': sk,
                'name': new_name if new_name is not None else existing_item.get('name'),
                'status': new_status if new_status is not None else existing_item.get('status')
            }
            table.put_item(Item=new_item_data)
            table.delete_item(Key={'PK': current_pk, 'SK': sk})

            return response(True, None, new_item_data)
        else:
            # Atualização comum (sem mudar PK)
            update_expression = "SET "
            expression_attribute_values = {}
            count = 0

            if new_name is not None:
                if count > 0:
                    update_expression += ", "
                update_expression += "name = :n"
                expression_attribute_values[':n'] = new_name
                count += 1

            if new_status is not None and new_status.upper() == "DONE":
                if count > 0:
                    update_expression += ", "
                update_expression += "status = :s"
                expression_attribute_values[':s'] = "DONE"
                count += 1

            if count == 0:
                return response(False, "No valid fields provided to update", None)

            update_response = table.update_item(
                Key={'PK': current_pk, 'SK': sk},
                UpdateExpression=update_expression,
                ExpressionAttributeValues=expression_attribute_values,
                ReturnValues="ALL_NEW"
            )
            updated_item = update_response.get('Attributes')

            return response(True, None, updated_item)

    except Exception as e:
        context.logger.error(f"Error: {str(e)}")
        return response(False, f"Could not update item: {str(e)}", None)

def response(success, error, item):
    response_data = {"success": success}
    if error:
        response_data["error"] = error
    if item:
        response_data["item"] = item
    return response_data