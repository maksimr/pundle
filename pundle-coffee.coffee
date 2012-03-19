#  @author: maksimr
#  @name: pundle-coffee
#  @description: Package manager for pentadactyl
#  @version: 0.1
#
#  Windows:
#  'rmdir /S /Q' :

"use strict"

bundleRoot = io.getRuntimeDirectories("plugins").shift().path

#BUNDLE
class Bundle
  constructor: (bundle) ->
    if this not instanceof Bundle then return new Bundle(bundle)

    #return package if package already exist
    return pack for pack in Bundle.packages when pack.name == bundle

    bundle = bundle.toString()
    uri = "https://github.com/#{bundle}.git"
    [author, name] = bundle.split('/')

    dir = io.getRuntimeDirectories("plugins").shift().child(name)

    @uri = uri
    @path = dir.path
    @author = author
    @name = name
    @instaled = dir.exists()

    Bundle.packages.push this

Bundle.packages = []

BundleInstall = (args)->
  packName = args.toString()
  pundle.install(packName)

BundleUpdate = (args)->
  packName = args.toString()
  pundle.update(packName)

BundleRemove = (args)->
  packName = args.toString()
  pundle.remove(packName)

#PUNDLE
pundle =
  info:
    version: "0.1"
    description: "Package manager for pentadactyl"

  plugins: dactyl.pluginFiles
  cmd:
    INSTALL: "git clone"
    UPDATE: "git pull"
    REMOVE: 'rm -rf'

  install: (packName)->
    packages = if packName then [Bundle(packName)] else Bundle.packages

    _cwd = io.cwd
    io.cwd = bundleRoot

    cmd = @cmd.INSTALL
    log = @log

    packages.forEach (pack)->
      unless pack.instaled
        output = pundle.exec(pack, "#{cmd} #{pack.uri}")
        log(pack.name, output)
    io.cwd = _cwd


  update: (packName)->
    packages = if packName then (pack for pack in Bundle.packages when pack.name == packName) else Bundle.packages

    _cwd = io.cwd
    cmd = @cmd.UPDATE
    log = @log

    packages.forEach (pack)->
      if pack.instaled
        io.cwd = pack.path
        output = pundle.exec(pack, "#{cmd}")
        log(pack.name, output)
    io.cwd = _cwd


  remove: (packName)->
    packages = Bundle.packages
    pack = p for p in packages when p.name == packName

    index = packages.indexOf(pack)
    packages.splice(index,index)
    cmd = "#{@cmd.REMOVE} #{pack.path}"

    output = pundle.exec(pack, cmd)

    @log(pack.name, output)

  exec: (pack, cmd)->
    try
      output = io.system cmd
    catch error
      output = error
    output

  log: (spec, output) ->
    dactyl.echomsg " "
    dactyl.echomsg "$ #{spec}"
    dactyl.echomsg "> #{output}"

  completer: (context)->
    context.completions = ([pack.name, pack.name] for pack in Bundle.packages)


#DECLARE PLUGIN
group.commands.add ["Bundle", "bund"], pundle.info.description, Bundle

group.commands.add ["BundleInstall", "bundi"], pundle.info.description, BundleInstall
group.commands.add ["BundleUpdate", "bundu"], pundle.info.description, BundleUpdate,
  literal: 0
  completer: pundle.completer

group.commands.add ["BundleRemove", "bundr"], pundle.info.description, BundleRemove,
  literal: 0
  completer: pundle.completer
