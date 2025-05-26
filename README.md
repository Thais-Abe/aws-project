# aws-project

Projeto AWS-Project  
Este projeto consiste em um conjunto de funções AWS Lambda desenvolvidas em **Python**, que se integram com **DynamoDB**, **Amazon Cognito** e **API Gateway**. As funções são empacotadas em `.zip` e implantadas na AWS para execução de forma serverless.

---

📌 **Visão Geral**  
Este projeto demonstra a construção de uma API RESTful utilizando serviços serverless da AWS: **Lambda (Python)** para lógica de negócio, **DynamoDB** como banco de dados NoSQL, **Amazon Cognito** para autenticação e **API Gateway** como camada de exposição HTTP das lambdas.

---

🔧 **Tecnologias Utilizadas**

- Python 3.11+
- Terraform – Provisionamento de infraestrutura como código (IaC)
- AWS Lambda (execução serverless)
- AWS API Gateway (exposição HTTP)
- AWS DynamoDB (banco de dados NoSQL)
- Amazon Cognito (autenticação de usuários)
- AWS SDK for Python (`boto3`)
- AWS CLI (para deploy e configuração)

---

⚙️ **Configuração do Projeto**

### Pré-requisitos

- Conta AWS
- AWS CLI configurada (`aws configure`)
- Python 3.9 ou superior
- `boto3` instalado (`pip install boto3`)

---

📡 **Recursos Criados**

### Lambda

As funções Lambda contêm a lógica de CRUD para recursos persistidos no DynamoDB. As funções são empacotadas com as dependências usando `zip` e são chamadas via API Gateway.

### DynamoDB

Criado como banco NoSQL para armazenar os dados manipulados pelas funções Lambda.

### Amazon Cognito

Utilizado para autenticação de usuários. Configurado um **User Pool** para login via e-mail/senha. O token JWT gerado é usado para autenticar chamadas no API Gateway.

### API Gateway

Exposto como interface REST para que clientes externos acessem as funções Lambda. Integrado com Amazon Cognito para autenticação via JWT.

---

🚀 **Deploy dos Recursos**

O provisionamento da infraestrutura pode ser feito via **Terraform** ou manualmente via **AWS Console**. No caso do Terraform, certifique-se de configurar o backend e os arquivos `*.tf` com os recursos abaixo:

- `aws_cognito_user_pool`
- `aws_api_gateway_rest_api`
- `aws_lambda_function`
- `aws_dynamodb_table`
- `aws_iam_role`

Para aplicar com Terraform:

```bash
cd terraform
terraform init -backend-config="dev.config"
terraform plan -var-file="environments/dev/terraform.tfvars"
terraform apply "dev.plan"

📌 Fluxo Básico de Trabalho com Git

🛠️ Configuração Inicial Clone o repositório:

bash git clone <URL_DO_REPOSITÓRIO> cd nome-do-projeto Sincronize com a branch principal (main ou dev):

bash git checkout main # ou dev, conforme o fluxo do projeto git pull origin main 🔀 Fluxo de Desenvolvimento

Criando uma Nova Branch Sempre crie uma branch a partir da branch atualizada de main/dev:
bash git checkout -b tipo/nome-da-branch Exemplos de prefixos:

feature/ – Novas funcionalidades.

fix/ – Correções de bugs.

docs/ – Atualizações de documentação.

chore/ – Tarefas de manutenção.

Commit das Alterações Adicione as mudanças e faça commits descritivos:
bash git add . # Adiciona todas as alterações git commit -m "Descrição clara" # Mensagem objetiva

Enviar para o Repositório Remoto bash git push origin nome-da-branch 🔄 Atualizando sua Branch Se a branch principal (main/dev) for atualizada enquanto você trabalha:
bash git checkout main # Volte para a branch principal git pull origin main # Atualize-a git checkout sua-branch # Volte para sua branch git merge main # Traga as atualizações 🚀 Enviando um Pull Request (PR) Acesse o repositório no GitHub/GitLab.

Abra um Pull Request da sua branch para main/dev.

Descreva as mudanças e aguarde a revisão.

✔️ Depois do PR Aprovado Merge no repositório remoto (via interface ou comando).

Exclua a branch local (opcional):

bash git branch -d nome-da-branch 📌 Regras Importantes ✔️ Nunca commite diretamente na main/dev. ✔️ Sempre teste antes de enviar um PR. ✔️ Use mensagens de commit claras (ex.: "Adiciona autenticação JWT").