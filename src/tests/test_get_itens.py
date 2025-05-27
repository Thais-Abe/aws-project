import pytest
from unittest.mock import patch
import json
import os
import sys
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
from lambdas_python.lambda_get_itens import get_itens

@pytest.fixture
def mock_event():
    return {
        'requestContext': {
            'authorizer': {
                'jwt': {
                    'claims': {
                        'sub': '123'
                    }
                }
            }
        }
    }

# teste em caso de sucesso na consulta ao DynamoDB
def test_lambda_handler_success(mock_event):
    mock_items = [{'PK': 'USER#123', 'SK': 'ITEM#1', 'name': 'item1'}]
    with patch.object(get_itens.TABLE, 'query', return_value={'Items': mock_items}):
        response = get_itens.lambda_handler(mock_event, None)
        body = json.loads(response['body'])
        assert response['statusCode'] == 200
        assert body['count'] == 1
        assert body['items'] == mock_items

# teste em caso de não haver itens
def test_lambda_handler_no_items(mock_event):
    with patch.object(get_itens.TABLE, 'query', return_value={'Items': []}):
        response = get_itens.lambda_handler(mock_event, None)
        body = json.loads(response['body'])
        assert response['statusCode'] == 200
        assert body['count'] == 0
        assert body['items'] == []

# teste em caso de exceção na consulta ao DynamoDB
def test_lambda_handler_exception(mock_event):
    with patch.object(get_itens.TABLE, 'query', side_effect=Exception("Dynamo error")):
        response = get_itens.lambda_handler(mock_event, None)
        body = json.loads(response['body'])
        assert response['statusCode'] == 500
        assert 'error' in body