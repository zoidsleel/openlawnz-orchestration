This is for Windows user
#!/bin/sh

## Set the variables  
data

echo "Creating mount volume directory"
mkdir data

echo "Running docker image"
docker pull postgres:latest
docker run --name openlawnz-postgres -p5432:5432 -v data:/var/lib/postgresql/data -d postgres:latest

echo "Downloading latest OpenLaw NZ database"
curl -o openlawnzdb.sql https:<URL provided by volunteering with OpenLaw NZ>

echo "Copying database into docker"
docker cp openlawnzdb.sql openlawnz-postgres:/tmp

echo "Restoring database into postgres instance" 
docker exec -it openlawnz-postgres psql -U postgres -c "create database openlawnz_db"
docker exec -it openlawnz-postgres pg_restore --no-owner -U postgres -d openlawnz_db /tmp/openlawnzdb.sql  -v

## Clean Up
docker exec openlawnz-postgres rm /tmp/openlawnzdb.sql
rm openlawnzdb.sql

