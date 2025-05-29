dynamodb_table_name = "bakery-bank"

billing_mode = "PAY_PER_REQUEST"

hash_key = "PK"

range_key = "SK"

lambda_configs = {
  lambda_add_items = {
    function_name = "lambda_add_items"
    handler       = "add_list_itens.lambda_add_to_list"
    runtime       = "python3.12"
    filename      = "src/lambdas_python/lambda-add-list-itens"
    source_path   = "src/lambdas_python/lambda-add-list-itens"
    environment_vars = {
      TABLE_NAME = "bakery-bank"
    }
    timeout     = 10  # Tempo em segundos
    memory_size = 250 # Tamanho da memória em MB (outro exemplo)
  },
  lambda_modify_itens = {
    function_name = "lambda_modify_itens"
    handler       = "update_list_itens.lambda_modify_itens"
    runtime       = "python3.12"
    filename      = "src/lambdas_python/lambda_update_list_itens"
    source_path   = "src/lambdas_python/lambda_update_list_itens"
    environment_vars = {
      TABLE_NAME = "bakery-bank"
    }
    timeout     = 10
    memory_size = 250
  },
  lambda_delete_itens = {
    function_name = "lambda_delete_itens"
    handler       = "delete_list_itens.lambda_delete_itens"
    runtime       = "python3.12"
    filename      = "src/lambdas_python/lambda-delete-list-itens"
    source_path   = "src/lambdas_python/lambda-update-list-itens"
    environment_vars = {
      TABLE_NAME = "bakery-bank"
    }
    timeout     = 10
    memory_size = 250
  },
  lambda_hello = {
    function_name = "lambda_hello"
    handler       = "hello.lambda_hello"
    runtime       = "python3.12"
    filename      = "src/lambdas_python/lambda-hello"
    source_path   = "src/lambdas_python/lambda-hello"
    environment_vars = {
      TABLE_NAME = "bakery-bank"
    }
    timeout     = 10
    memory_size = 250
  },
  lambda_get_itens = {
    function_name = "lambda_get_itens"
    handler       = "get_itens.lambda_get_itens"
    runtime       = "python3.12"
    filename      = "src/lambdas_python/lambda_get_itens"
    source_path   = "src/lambdas_python/lambda_get_itens"
    environment_vars = {
      TABLE_NAME = "bakery-bank"
    }
    timeout     = 10
    memory_size = 250
  },
}