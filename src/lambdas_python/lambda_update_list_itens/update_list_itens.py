import os
import boto3
import logging
import json


logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_modify_itens(event, context):
    dynamodb = boto3.resource("dynamodb")
    table_name = os.environ.get("TABLE_NAME")
    table = dynamodb.Table(table_name)

    authorizer = event.get("requestContext", {}).get("authorizer", {})
    claims = authorizer.get("claims") or authorizer.get("jwt", {}).get("claims")

    if not claims or "sub" not in claims:
        return {
            "statusCode": 401,
            "body": json.dumps(
                {"message": "Usuário não autenticado ou token inválido."}
            ),
        }

    user_id = claims["sub"]

    item_id = None
    if event.get("queryStringParameters"):
        item_id = event["queryStringParameters"].get("itemId")

    updates = None
    if event.get("body"):
        try:
            body = json.loads(event["body"])
            updates = body.get("updates")
        except Exception as e:
            logger.error(f"Erro ao parsear body JSON: {str(e)}")
            return response(False, "Invalid JSON body", None)

    pk = f"USER#{user_id}"
    sk = f"ITEM#{item_id}"

    if not pk or not sk or not updates:
        return response(
            False,
            "Missing required parameters: 'listPk', 'itemId' and/or 'updates'",
            None,
        )

    new_name = updates.get("name")
    new_date = updates.get("date")
    new_status = updates.get("status")
    expression_attribute_names = {}

    try:
        existing_item = table.get_item(Key={"PK": pk, "SK": sk}).get("Item")

        if not existing_item:
            return response(False, "Item not found", None)

        update_fields = []
        expression_attribute_values = {}

        if new_name is not None:
            update_fields.append("#n = :n")
            expression_attribute_values[":n"] = new_name
            expression_attribute_names["#n"] = "name"

        if new_status is not None and new_status.upper() == "DONE":
            update_fields.append("#s = :s")
            expression_attribute_values[":s"] = "DONE"
            expression_attribute_names["#s"] = "status"

        if new_date is not None:
            update_fields.append("#d = :d")
            expression_attribute_values[":d"] = new_date
            expression_attribute_names["#d"] = "date"

        if not update_fields:
            return response(False, "No valid fields provided to update", None)

        update_expression = "SET " + ", ".join(update_fields)

        update_response = table.update_item(
            Key={"PK": pk, "SK": sk},
            UpdateExpression=update_expression,
            ExpressionAttributeValues=expression_attribute_values,
            ExpressionAttributeNames=expression_attribute_names,
            ReturnValues="ALL_NEW",
        )

        updated_item = update_response.get("Attributes")

        return response(True, None, updated_item)

    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return response(False, f"Could not update item: {str(e)}", None)


def response(success, error, item):
    response_data = {"success": success}
    if error:
        response_data["error"] = error
    if item:
        response_data["item"] = item
    return json.dumps(response_data)
