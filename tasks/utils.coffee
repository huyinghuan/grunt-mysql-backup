_path = require 'path'
_fs = require 'fs'
_mkdirp = require 'mkdirp'
_moment = require 'moment'
_exec = require('child_process').exec

Utils = module.exports = {}

#备份sql的目录
getBackupDirectory = (dir = 'backup')->
  dir = _path.join process.cwd(), dir
  _mkdirp.sync dir
  return dir

#生成备份文件路径
generateBackupFilePath = (filePath)->
  dir = getBackupDirectory(filePath)
  nowTime = _moment().format("YYYYMMDDHHmmss")
  _path.join dir, "#{nowTime}.sql"

#获取最近一次备份文件路劲
getNewestSqlFile = (filePath)->
  dir = getBackupDirectory(filePath)
  files = _fs.readdirSync(dir)
  files.sort()
  filename = files.pop()
  return false if not filename
  _path.join dir, filename

#获取导出数据库sql
getImportSQL = (connection, filename)->
  "mysql
      --user=#{connection.user}
      --password=#{connection.password}
      --host=#{connection.host}
      --port=#{connection.port or 3306}
      --database=#{connection.database}
      < #{filename}"
#  仅支持5.6以及以上版本
#  "mysqldbimport
#      --server=#{connection.user}:#{connection.password}@#{connection.host}:#{connection.port or 3306}
#      --import=both
#      --format=sql
#      #{filename}"

#获取备份数据库sql
getExportSQL = (connection,  filename)->
  "mysqldump
        --opt
        --host=#{connection.host}
        --port=#{connection.port or 3306}
        --user=#{connection.user}
        --password=#{connection.password}
        --database #{connection.database}
        >> #{filename}"

doBackupFail = (error, filename)->
  _fs.unlinkSync filename if _fs.existsSync filename
  console.log "备份失败! #{error}"

doBackupSuccess = ()->
  console.log "备份成功!"

doRecoveryFail = (error)->
  console.log "还原失败! #{error}"

doRecoverySuccess = (msg)->
  console.log msg

Utils.doBackup = (options, data, cb)->
  filename = generateBackupFilePath data.dir
  shell =  getExportSQL options, filename
  console.log 'doBackup', shell
  _exec shell, (err)->
    return doBackupFail err, filename  if err
    doBackupSuccess()
    cb && cb()

Utils.doRecovery = (options, data, cb)->
  filename = getNewestSqlFile data.dir
  filename = data.dest if data.dest
  return doRecoveryFail("#{filename} 文件不存在") if not _fs.existsSync filename
  shell = getImportSQL options, filename
  console.log 'doRecovery', shell
  _exec(shell, (error)->
    return doRecoveryFail "还原失败! #{error}" if error
    doRecoverySuccess "还原成功! #{filename}"
    cb && cb()
  )

