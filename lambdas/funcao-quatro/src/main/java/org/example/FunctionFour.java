package org.example;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.HashMap;
import java.util.Map;

public class FunctionFour implements RequestHandler<Map<String, Object>, Map<String, Object>> {

    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.defaultClient();
    private final DynamoDB dynamoDB = new DynamoDB(client);
    private final String tableName = System.getenv("TABLE_NAME");

    @Override
    public Map<String, Object> handleRequest(Map<String, Object> input, Context context) {
        String listPk = (String) input.get("listPk"); // data da lista
        String itemId = (String) input.get("itemId"); // id do item

        if (listPk == null || itemId == null) {
            return response(false, "Missing required parameters: 'listPk' and/or 'itemId'");
        }

        String pk = "LIST#" + listPk;
        String sk = "ITEM#" + itemId;

        Table table = dynamoDB.getTable(tableName);

        try {
            // Verifica se o item existe antes de deletar (para idempotência e evitar erro 400)
            Item existingItem = table.getItem("PK", pk, "SK", sk);

            if (existingItem != null) {
                table.deleteItem("PK", pk, "SK", sk);
            }

            // Mesmo se o item já não existir, consideramos sucesso (idempotência)
            return response(true, null);

        } catch (Exception e) {
            context.getLogger().log("Error deleting item: " + e.getMessage());
            return response(false, "Could not delete item: " + e.getMessage());
        }
    }

    private Map<String, Object> response(boolean success, String error) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", success);
        if (!success && error != null) {
            response.put("error", error);
        }
        return response;
    }
}

