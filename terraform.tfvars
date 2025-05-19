function_configs = {
  lambda_add_items = {
    function_name    = "lambda_add_items"
    handler          = "add_list_itens.lambda_add_to_list"
    runtime          = "python3.12"
    filename         = "src/lambdas-python/lambda-add-list-itens/lambda_add_itens.zip"
    environment_vars = {
      TABLE_NAME = "bakery-bank"
    }
    timeout          = 10 # Tempo em segundos
    memory_size      = 250 # Tamanho da memória em MB (outro exemplo)
  }
}