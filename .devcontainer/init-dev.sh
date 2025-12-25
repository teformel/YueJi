#!/bin/bash
set -e

echo "Starting Dev Container Initialization..."

# Install dependencies
echo "Installing system dependencies..."
sudo apt-get update
sudo apt-get install -y postgresql-client

echo "Installing npm dependencies..."
npm install

echo "Building Maven project..."
mvn clean install -DskipTests

# Wait for DB
echo "Waiting for database to be ready..."
until pg_isready -h db -p 5432 -U yueji_user; do
  echo "Database is unavailable - sleeping"
  sleep 2
done

echo "Database is up - executing initialization..."
echo "Resetting database..."
export PGPASSWORD=yueji_password
psql -h db -U yueji_user -d postgres -c "DROP DATABASE IF EXISTS yueji_db WITH (FORCE);"
psql -h db -U yueji_user -d postgres -c "CREATE DATABASE yueji_db;"

mvn exec:java -Dexec.mainClass="com.yueji.tool.DbInit"

echo "Dev Container Initialization Complete!"
