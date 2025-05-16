import json
import os
import uuid
import boto3
from botocore.exceptions import ClientError


bank = "dynamodb";
tableName = "TABLE_NAME";
nameTyped = "name";
dateTyped = "date";

dynamodb = boto3.resource(bank)
table_name = os.getenv(tableName)
table = dynamodb.Table(table_name)

def lambda_add_to_list(event, context):
    name = event.get(nameTyped)
    date = event.get(dateTyped)

    if not name or not date:
        return {
            "statusCode": 400,
            "body": json.dumps({
                "success": False,
                "error": "Missing required fields: 'name' and/or 'date'"
            }),
            "headers": {"Content-Type": "application/json"}
        }

    item_id = str(uuid.uuid4())

    try:
        table.put_item(
            Item={
                "PK": f"LIST#{date}",
                "SK": f"ITEM#{item_id}",
                "name": name,
                "status": "todo"
            }
        )

        return {
            "statusCode": 200,
            "body": json.dumps({
                "success": True,
                "item": {
                    "PK": date,
                    "SK": item_id,
                    "name": name,
                    "status": "todo"
                }
            }),
            "headers": {"Content-Type": "application/json"}
        }

    except ClientError as e:
        return {
            "statusCode": 500,
            "body": json.dumps({
                "success": False,
                "error": e.response["Error"]["Message"]
            }),
            "headers": {"Content-Type": "application/json"}
        }
