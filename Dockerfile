# Use a imagem oficial do Ruby como base
FROM ruby:3.1.2

# Instale dependências do sistema
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Crie o diretório de trabalho e defina-o como o diretório atual
WORKDIR /quickmesa

# Copie o Gemfile e o Gemfile.lock para o diretório de trabalho
COPY Gemfile /quickmesa
COPY Gemfile.lock /quickmesa

# Instale as gems
RUN bundle install

# Copie o restante do código da aplicação para o diretório de trabalho
COPY . /quickmesa

# Configure o comando para iniciar o servidor
CMD ["rails", "server", "-b", "0.0.0.0"]