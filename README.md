# GitScrapper

Aplicação Rails 8.0.2 com Hotwire para cadastrar perfis do GitHub e realizar scraping de informações públicas.

## Pré-requisitos
- Ruby 3.4.4
- Rails 8.0.2
- PostgreSQL
- Docker + Docker Compose (opcional)

## Setup local
Execute o script de setup para instalar as dependências, criar o banco de dados com os seeds e iniciar o servidor:
```
 bin/setup
```

Caso queira apenas preparar o ambiente sem subir o servidor, use:
```
bin/setup --skip-server
```

## Setup com docker
Para criar as imagens, subir os containers e inicializar a aplicação com o ambiente pronto:
```
docker compose up
```

Para acessar o terminal do container da aplicação:
```
docker compose run --rm --service-ports web bash
```
>💡 Esse comando também cria as imagens e sobe os containers automaticamente, caso ainda não existam. Para preparar o ambiente e/ou inicializar a aplicação, executar `bin/setup --skip-server` ou `bin/setup`

## Técnicas Utilizadas
- Ruby on Rails 8.0.2 – Framework principal da aplicação
- Hotwire (Turbo Frame, Turbo Stream) – Atualizações dinâmicas de seções da página sem recarregamento completo
- Service Objects – Organização da lógica de negócio externa ao controller
- Web Scraping com Faraday + Nokogiri – Requisições HTTP e parsing de HTML para extrair dados públicos de perfis do GitHub
- Internacionalização (i18n) – Textos adaptados para português via dicionários YAML
- Validações com ActiveRecord e tratamento de exceções – Garantia de integridade e consistência dos dados no modelo e nos serviços
- Arquitetura RESTful – Estrutura de controllers e rotas seguindo as convenções REST do Rails
- Layout responsivo com Bootstrap
- Testes automatizados com RSpec, FactoryBot, ShouldaMatchers e Webmock
- Docker e Docker Compose – Containerização para ambiente de desenvolvimento

## Pontos de melhoria
- Melhoria no layout das páginas (ex: toast com stimulus para mensagens de feedback)
- Melhoria no tratamento de erros
- Paginação na listagem de perfis
- Melhoria na cobertura de testes (unitários, request e aceitação com capybara)
- Implementação de logs técnicos para monitoramento de erros
