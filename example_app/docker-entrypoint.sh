#!/bin/sh

set -e

rm -f $APP_DIR/tmp/pids/server.pid
rm -f $APP_DIR/tmp/pids/sidekiq.pid

bin/rails db:create
bin/rails db:migrate

exec "$@"
