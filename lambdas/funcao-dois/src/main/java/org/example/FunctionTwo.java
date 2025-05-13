package org.example;

import java.util.Map;
import java.util.UUID;

import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.document.DynamoDB;
import com.amazonaws.services.dynamodbv2.document.Item;
import com.amazonaws.services.dynamodbv2.document.PutItemOutcome;
import com.amazonaws.services.dynamodbv2.document.Table;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;

public class FunctionTwo implements RequestHandler<Map<String, String>, Map<String, Object>> {

    private final AmazonDynamoDB client = AmazonDynamoDBClientBuilder.defaultClient();
    private final DynamoDB dynamoDB = new DynamoDB(client);
    private final String tablename = System.getenv("TABLE_NAME");

    @Override
    public Map<String, Object> handleRequest(Map<String, String> input, Context context) {
        String name = input.get("name");
        String date = input.get("date");

        if (name == null || date == null) {
            return Map.of("success", false, "error", "Missing required fields: 'name' and/or 'date'");
        }

        String itemId = UUID.randomUUID().toString();

        Table table = dynamoDB.getTable(tablename);
        Item item = new Item()
                .withPrimaryKey("PK","LIST#" + date, "SK", "ITEM#"+ itemId)
                .withString("name", name)
                .withString("status", "todo");

        PutItemOutcome outcome = table.putItem(item);

        return Map.of(
                "success", true,
                "item", Map.of(
                        "PK", date,
                        "SK", itemId,
                        "name", name,
                        "status", "todo"
                )
        );
    }
}
