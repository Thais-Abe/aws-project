package org.example;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.dynamodbv2.document.UpdateItemOutcome;
import com.amazonaws.services.dynamodbv2.document.spec.UpdateItemSpec;
import com.amazonaws.services.dynamodbv2.document.utils.ValueMap;
import com.amazonaws.services.dynamodbv2.model.ReturnValue;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

import java.util.HashMap;
import java.util.Map;

public class FunctionThree implements RequestHandler<Map<String, Object>, Map<String, Object>> {

    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.defaultClient();
    private final DynamoDB dynamoDB = new DynamoDB(client);
    private final String tableName = System.getenv("TABLE_NAME");

    @Override
    public Map<String, Object> handleRequest(Map<String, Object> input, Context context) {
        String listPk = (String) input.get("listPk"); // data atual
        String itemId = (String) input.get("itemId");
        Map<String, Object> updates = (Map<String, Object>) input.get("updates");

        if (listPk == null || itemId == null || updates == null) {
            return response(false, "Missing required parameters: 'listPk', 'itemId' and/or 'updates'", null);
        }

        String newName = (String) updates.get("name");
        String newDate = (String) updates.get("date");
        String newStatus = (String) updates.get("status");

        Table table = dynamoDB.getTable(tableName);
        String currentPk = "LIST#" + listPk;
        String sk = "ITEM#" + itemId;

        try {
            Item existingItem = table.getItem("PK", currentPk, "SK", sk);
            if (existingItem == null) {
                return response(false, "Item not found", null);
            }

            // Se a data mudou, copia para nova PK e deleta o antigo
            boolean dateChanged = newDate != null && !newDate.equals(listPk);
            if (dateChanged) {
                String newPk = "LIST#" + newDate;

                // Criar novo item com os dados atualizados
                Item newItem = new Item()
                        .withPrimaryKey("PK", newPk, "SK", sk)
                        .withString("name", newName != null ? newName : existingItem.getString("name"))
                        .withString("status", newStatus != null ? newStatus : existingItem.getString("status"));

                table.putItem(newItem);
                table.deleteItem("PK", currentPk, "SK", sk);

                return response(true, null, newItem.asMap());
            } else {
                // Atualização comum (sem mudar PK)
                StringBuilder updateExpression = new StringBuilder("SET ");
                ValueMap valueMap = new ValueMap();
                int count = 0;

                if (newName != null) {
                    if (count > 0) updateExpression.append(", ");
                    updateExpression.append("name = :n");
                    valueMap.withString(":n", newName);
                    count++;
                }

                if (newStatus != null && newStatus.equalsIgnoreCase("DONE")) {
                    if (count > 0) updateExpression.append(", ");
                    updateExpression.append("status = :s");
                    valueMap.withString(":s", "DONE");
                    count++;
                }

                if (count == 0) {
                    return response(false, "No valid fields provided to update", null);
                }

                UpdateItemSpec updateItemSpec = new UpdateItemSpec()
                        .withPrimaryKey("PK", currentPk, "SK", sk)
                        .withUpdateExpression(updateExpression.toString())
                        .withValueMap(valueMap)
                        .withReturnValues(ReturnValue.ALL_NEW);

                UpdateItemOutcome outcome = table.updateItem(updateItemSpec);
                Item updatedItem = outcome.getItem();

                return response(true, null, updatedItem.asMap());
            }

        } catch (Exception e) {
            context.getLogger().log("Error: " + e.getMessage());
            return response(false, "Could not update item: " + e.getMessage(), null);
        }
    }

    private Map<String, Object> response(boolean success, String error, Object item) {
        Map<String, Object> response = new HashMap<>();
        response.put("success", success);
        if (error != null) {
            response.put("error", error);
        }
        if (item != null) {
            response.put("item", item);
        }
        return response;
    }
}
