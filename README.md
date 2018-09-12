# kdb+/q server
### Run the 32-bit kdb+/q database inside a Docker container

```sh
# Basic server
docker run -p 5000:5000 -d kdbq:3.6
```

### Load and execute a `q` script on startup
Probably the most useful feature. Typically the startup script is used to set up
tables, load historical databases, define custom functions, etc.

This can be used by passing the script (the code itself, not a path to the file!)
to `ON_STARTUP` ENV variable.

*Example: `-e ON_STARTUP="$(cat path/to/script.q)"`*


### Where to mount the persistent volume?
kdb+ inside the container starts from `/root/` (or `~/`), so any calls to relative
paths will be bound to that.

*Example: `-v "$(pwd)/data":/root/data`*. Then, you can
[load or save HDB](https://code.kx.com/q4m3/11_IO/#113-splayed-tables)
from/to the persistent `data` directory:
```
`:data/tableName/ set tableName
```


### Set up a simple authentication
kdb+ features
[a simple user-password authentication](https://code.kx.com/q/ref/cmdline/#-u-usr-pwd-local).
This can be used by setting the `AUTH` ENV variable.

User-password keys are provided in the shape `user:password`.
The password can be also MD5-hashed: `user:5f4dcc3b5aa765d61d8327deb882cf99`.
Use one way of specifying passwords per file.

*Example: `-e AUTH="$(cat auth.txt)"` where `auth.txt` stores
a list of `user:password` pairs. Instead of `cat`ing a file, you can
also directly write in the userpass `-e AUTH="user:password"`*

If you wish to use more advanced authentication using `.z.pw`, please
write your event handlers in a `.q` file and load this file on startup.


### Run as a console
Pass `-it` flags instead of `-d` to `docker run` call.

Just note the goal was to keep the image as small as possible, so there is not
`rlwrap` installed and thus the `q)` console doesn't remember its history.


## Examples
You can clone [this repo](https://github.com/kysely/kdbq-server) and try out
the database with provided example files from `examples/` directory.

### Startup script with database load
The following `docker run` command will mount the `data` dir into the container
and the startup script will load a data set from that mounted directory.

```sh
docker run -it -v "$(pwd)/data":/root/data -e ON_STARTUP="$(cat examples/load_data.q)" kdbq:3.6
```

Then, because your server is set up, you can run queries on the loaded
`fisher_river` table. Try this one in the console:
```q
select low:min celsius, mean:avg celsius, high: max celsius by `date$3 xbar `month$day from fisher_river
```
(this query buckets the data into year quarters, then checks lowest/average/highest
temperature in each of the quarters)



### Default authentication
Run the following `docker run` command, then go to [localhost:5000](http://localhost:5000).
You'll be prompted to enter the username and password (you can use
`admin:admin` or `user:password`).

```sh
docker run -it -p 5000:5000 -e AUTH="$(cat examples/users.txt)" kdbq:3.6
```


## License
The Docker resource files for 32-bit kdb+/q server are licensed under the
[MIT license](https://github.com/kysely/kdbq-server/blob/master/LICENSE).

---

The kdb+ 32-bit Personal Edition is free for non-commercial use.
[Please read and accept the terms and conditions on Kx Systems site](https://kx.com/download/).
If you do not agree to those terms and conditions, please don't use the software.

> 1.1. "Commercial Use" means any use of the 32 Bit Kdb+ Software for the User or any third party'sfinancial gain or other economic benefit. Any Beta-testing or production use of a User Application is Commercial Use. Notwithstanding the foregoing, the following are not Commercial Uses: (a) use solely for educational or personal purposes; (b) use by a registered charity or licensed educational institution, (c) development of a proof-of-concept application, even in a commercial setting; and (d) any use for which Kx has granted the User written permission.

---

Example data set _Mean daily temperature, Fisher River near Dallas, Jan 01, 1988 to Dec 31, 1991_
by Hipel and McLeod (1994). Downloaded from [DataMarket](https://datamarket.com/data/set/235d/mean-daily-temperature-fisher-river-near-dallas-jan-01-1988-to-dec-31-1991#!ds=235d&display=line).
