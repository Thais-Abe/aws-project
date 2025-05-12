# aws-project
Projeto AWS-Project
Este projeto consiste em um conjunto de funções AWS Lambda desenvolvidas em Java, utilizando Maven como ferramenta de build. Uma das Lambdas interage com um banco de dados DynamoDB para realizar operações de CRUD (Create, Read, Update, Delete).

📌 Visão Geral
O projeto tem como objetivo demonstrar a integração entre AWS Lambda e DynamoDB usando Java. As funções Lambda são empacotadas e implantadas na AWS, permitindo a execução de processos serverless escaláveis.

🔧 Tecnologias Utilizadas
Java (JDK 11 ou superior)

Maven (para gerenciamento de dependências e build)

AWS Lambda (execução serverless)

AWS DynamoDB (banco de dados NoSQL)

AWS SDK for Java (integração com serviços AWS)

⚙️ Configuração do Projeto
Pré-requisitos
Conta AWS

AWS CLI configurada (aws configure)

Java JDK 11+

Maven instalado

📌 Fluxo Básico de Trabalho com Git

🛠️ Configuração Inicial
Clone o repositório:

bash
git clone <URL_DO_REPOSITÓRIO>
cd nome-do-projeto
Sincronize com a branch principal (main ou dev):

bash
git checkout main   # ou dev, conforme o fluxo do projeto
git pull origin main
🔀 Fluxo de Desenvolvimento
1. Criando uma Nova Branch
Sempre crie uma branch a partir da branch atualizada de main/dev:

bash
git checkout -b tipo/nome-da-branch
Exemplos de prefixos:

feature/ – Novas funcionalidades.

fix/ – Correções de bugs.

docs/ – Atualizações de documentação.

chore/ – Tarefas de manutenção.

2. Commit das Alterações
Adicione as mudanças e faça commits descritivos:

bash
git add .                         # Adiciona todas as alterações
git commit -m "Descrição clara"   # Mensagem objetiva

3. Enviar para o Repositório Remoto
bash
git push origin nome-da-branch
🔄 Atualizando sua Branch
Se a branch principal (main/dev) for atualizada enquanto você trabalha:

bash
git checkout main          # Volte para a branch principal
git pull origin main      # Atualize-a
git checkout sua-branch   # Volte para sua branch
git merge main            # Traga as atualizações
🚀 Enviando um Pull Request (PR)
Acesse o repositório no GitHub/GitLab.

Abra um Pull Request da sua branch para main/dev.

Descreva as mudanças e aguarde a revisão.

✔️ Depois do PR Aprovado
Merge no repositório remoto (via interface ou comando).

Exclua a branch local (opcional):

bash
git branch -d nome-da-branch
📌 Regras Importantes
✔️ Nunca commite diretamente na main/dev.
✔️ Sempre teste antes de enviar um PR.
✔️ Use mensagens de commit claras (ex.: "Adiciona autenticação JWT").
