FROM ruby:2.5.7

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# throw errors if Gemfile has been modified since Gemfile.lock
RUN apt-get update && apt-get install -y \
  build-essential nodejs yarn

RUN apt-get install yarn -y

RUN bundle config --global frozen 1

RUN mkdir -p /evapp

WORKDIR /evapp
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler -v 2.0.1
RUN bundle install

COPY . ./

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
