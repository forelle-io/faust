# Faust [![Build Status](https://api.travis-ci.com/forelle-io/faust.png?branch=master)](https://travis-ci.org/forelle-io/faust) [![Coverage Status](https://coveralls.io/repos/github/forelle-io/faust/badge.svg)](https://coveralls.io/github/forelle-io/faust)

<img src="https://github.com/forelle-io/faust/blob/master/assets/static/images/logotype.png" height="128">

## О проекте Forelle
Платформа нового поколения для рыболовного сообщества.

## Манифест команды
1. Платформа должна быть понятна, удобна, надежна и безопасна
2. Мы любим свой язык и гордимся им. Поэтому разработка ведется с учетом максимального использования русского языка
3. Реализуемые и адекватные пожелания пользователей должны реализовываться в короткие сроки

## Развертывание платформы

#### Установка `asdf` менеджера

Обновление системы и установка требуемых зависимостей
```bash
$ sudo apt update && sudo apt upgrade && sudo apt install git automake autoconf libreadline-dev libncurses-dev libssl-dev libyaml-dev libxslt-dev libffi-dev libtool unixodbc-dev openjdk-11-jre openjdk-11-jdk fop libncurses5-dev unixodbc-dev g++ libssl-dev libwxgtk3.0-dev xsltproc libwxbase3.0-dev libqt4-opengl-dev libgtk2.0-dev inotify-tools
```
Клонирование исходников `asdf` менеджера на целевую машину
```bash
$ git clone https://github.com/asdf-vm/asdf.git ~/.asdf
```

После клонирования необходимо добавить в `.bashrc` инициализацию `asdf`
```bash
$ echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.bashrc
$ echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.bashrc
$ . ~/.bashrc
```

Проверить доступность менеджера, запросив его версию
```bash
$ asdf --version
```

С помощью менеджера добавить и установить плагин `Erlang`
```bash
$ asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && asdf install erlang 21.3.2
```

С помощью менеджера добавить и установить плагин `Elixir`
```bash
$ asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git && asdf install elixir 1.8.1
```

#### Запуск платформы `Faust`

Склонировать проект `Faust` в текущую папку
```bash
$ git clone git@github.com:forelle-io/faust.git
```

Создать пользователя в СУБД `PostgreSQL`:
```sql
CREATE USER faust WITH PASSWORD 'faust' CREATEDB;
```

Установить требуемые `JavaScript` библиотеки для `NPM`
```bash
$ cd faust/assets && npm install
```

В корневой папке получить все зависимости и создать через библиотеку `ecto` базу данных
```bash
$ cd ../faust && mix deps.get && mix ecto.create
```

На созданную базу данных в `PostgreSQL` добавить все допустимые привилегии для пользователя `faust`
```sql
GRANT ALL PRIVILEGES ON DATABASE faust_dev TO faust;
```

Произвести миграцию в корневой папке, запустить `seed` задачу и сервер `cowboy`
```bash
$ mix ecto.migrate && && mix run priv/repo/seeds.exs && mix phx.server
```

В случае успешного запуска сервера, платформа станет доступна по адресу [http://localhost:4000/](http://localhost:4000/)
