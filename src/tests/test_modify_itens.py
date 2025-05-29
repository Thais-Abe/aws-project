import json
from botocore.exceptions import ClientError
from lambdas_python.lambda_update_list_itens.update_list_itens import (
    lambda_modify_itens,
)


def test_modify_itens_succes(
    mock_dynamodb_table, mock_get_item, mock_update_item, update_body
):

    mock_dynamodb_table.get_item.return_value = mock_get_item
    mock_dynamodb_table.update_item.return_value = mock_update_item

    result = lambda_modify_itens(update_body, None)
    response = json.loads(result)

    assert response["success"] is True
    assert response["item"]["name"] == "buy milk"
    assert response["item"]["status"] == "DONE"
    assert response["item"]["date"] == "2025-12-12"


def test_modify_itens_item_not_found(mock_dynamodb_table, update_body):
    mock_dynamodb_table.get_item.return_value = {}
    result = lambda_modify_itens(update_body, None)
    response = json.loads(result)

    assert response["success"] is False
    assert "not found" in response["error"].lower()


def test_modify_itens_dynamodb_error(mock_dynamodb_table, mock_get_item, update_body):
    from botocore.exceptions import ClientError

    mock_dynamodb_table.get_item.return_value = mock_get_item
    mock_dynamodb_table.update_item.side_effect = ClientError(
        error_response={
            "Error": {
                "Code": "ConditionalCheckFailedException",
                "Message": "Conditional check failed",
            }
        },
        operation_name="UpdateItem",
    )

    result = lambda_modify_itens(update_body, None)
    response = json.loads(result)

    assert response["success"] is False
    assert "conditional" in response["error"].lower()


def test_modify_itens_invalid_body(mock_dynamodb_table, mock_get_item, update_body):
    update_body["body"] = json.dumps({"foo": "bar"})
    mock_dynamodb_table.get_item.return_value = mock_get_item

    result = lambda_modify_itens(update_body, None)
    response = json.loads(result)

    assert response["success"] is False
    assert "missing" in response["error"].lower()
