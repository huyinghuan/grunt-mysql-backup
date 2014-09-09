grunt-mysql-backup
=============
backup mysql database or recovery mysql

## Install
```shell
npm install grunt-mysql-backup
```

## How to use

### options
connect mysql options

#### options.user
log in mysql username. default is ```root```

#### options.password
log in mysql password. default is ```''```

#### options.host
the host of mysql. default is ```localhost```

#### options.port
the port of mysql. default is ```3306```

#### options.database
the database name that need be backup or recover. default is ```undefined```

### How to backup database?

#### tasks
plugin will do backup task that task name begin with ```backup```. 

for example:

```
backup:{...}
backup-test: {...}
```
#### tasks.dir
The directory that  backup sql file will be save. default is ```backup```

for example:

```
backup:{
  dir: "mysql-backup-dir"
}
```

### How to recover by sql ?

plugin will do recover task that task name begin with ```recovery```. for example:

```
recovery:{...}
recovery-test: {...}
```


#### tasks.dest
the file path of sql. default is the file in ```backup``` directory. chooss the sql file by lexicographic order

