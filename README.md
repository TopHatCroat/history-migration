### Instructions

* Run `docker image build -t postgres_test:1.0 .` to build the image
* Run `docker container run -d -p 5432:5432 --name postgres_test postgres_test:1.0` to run it
    This will initialize the database with the values in `./init.sql` and expose port 5432 so we can run scripts on it using `psql` command
* Run `psql -U postgres -h 127.0.0.1 -f upgrade.sql –no-password`
