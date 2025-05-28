import pytest
import json
import os
from unittest.mock import patch, MagicMock

os.environ["TABLE_NAME"] = "test_table"


@pytest.fixture
def user_event(sub="test-user-id"):
    return {"requestContext": {"authorizer": {"jwt": {"claims": {"sub": sub}}}}}


@pytest.fixture(autouse=True)
def mock_dynamodb_table():
    with patch("boto3.resource") as mock_resource:
        mock_table = MagicMock()
        mock_resource.return_value.Table.return_value = mock_table
        yield mock_table


@pytest.fixture
def update_body(user_event):
    user_event["body"] = json.dumps(
        {"updates": {"name": "buy milk", "date": "2025-12-12", "status": "DONE"}}
    )
    user_event["queryStringParameters"] = {"itemId": "item-123"}
    return user_event


@pytest.fixture
def mock_get_item():
    return {
        "Item": {
            "PK": "USER#test-user-id",
            "SK": "ITEM#item-123",
            "name": "old name",
            "date": "2025-01-01",
            "status": "todo",
        }
    }


@pytest.fixture
def mock_update_item():
    return {
        "Attributes": {
            "PK": "USER#test-user-id",
            "SK": "ITEM#item-123",
            "name": "buy milk",
            "date": "2025-12-12",
            "status": "DONE",
        }
    }
