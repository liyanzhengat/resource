#!/bin/bash
# Restore database from a backup file
# Usage: restore.sh backup_file
#   backup_file: a sql file, usually generated by pg_dump. Should

# Rails project's path, used to run db:migrate task and restart passenger
# Not required
PROJECT_DIR=/rails_apps/resource-center/current/
export RAILS_ENV=staging

# PostgreSQL cannot drop currently opened database,
# so it's necessary to connect to another database when droping database
MASTER_DATABASE=postgres
DB_HOST=localhost
DB_USER=postgres
DB_PASS=your_password
DB_NAME=resource_center_staging

backup_file=$1
if [[ -z "$backup_file" ]]; then
  echo "Supply a backup file to restore from!" 1>&2
  exit 1
elif [[ ! -f "$backup_file" ]]; then
  echo "File '$backup_file' not exists!" 1>&2
  exit 1
fi

cat <<-SQL | PGPASSWORD="$DB_PASS" psql --quiet -h "$DB_HOST" -U "$DB_USER" -d "$MASTER_DATABASE"
  SELECT pg_terminate_backend(pid)
  FROM pg_stat_activity
  WHERE
    -- don't kill my own connection!
    pid <> pg_backend_pid()
    -- don't kill the connections to other databases
    AND datname = '$DB_NAME'
  ;

  DROP DATABASE IF EXISTS "$DB_NAME";
  CREATE DATABASE "$DB_NAME" ENCODING 'utf8';
SQL

if [[ "$?" != "0" ]]; then
  echo "Failed to drop database $DB_NAME" 1>&2
  exit 2
fi

PGPASSWORD="$DB_PASS" psql --quiet -h "$DB_HOST" -U "$DB_USER" -d "$DB_NAME" -f "$backup_file"

if [[ "$?" != "0" ]]; then
  echo "Failed to restore database data" 1>&2
  exit 2
fi

if [[ -n "$PROJECT_DIR" ]]; then
  if [[ -d "$PROJECT_DIR" ]]; then
    cd "$PROJECT_DIR"
    # Migrate and seed database
    bundle exec rake db:migrate
    bundle exec rake db:seed_fu

    # Restart passenger
    if which passenger-config &> /dev/null; then
      passenger-config restart-app --ignore-passenger-not-running --ignore-app-not-running "$PROJECT_DIR"
    fi
  else
    echo "'$PROJECT_DIR' is not a valid directory!" 1>&2
    exit 2
  fi
fi
