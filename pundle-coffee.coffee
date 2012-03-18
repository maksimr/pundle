#  @author: maksimr
#  @name: pundle-coffee
#  @description: Package manager for pentadactyl
#  @version: 0.1

"use strict"

bundleDir = io.getRuntimeDirectories('plugins/bundle').shift()

bundles = bundleDir.readDirectory(true).filter (dir)->
  dir.child(".git").exists()

pundle =
  info:
    version: "0.1"
    description: "Package manager for pentadactyl"

  execute: (args) ->
    dirs = args['-directories'] or args['-D']
    dirs = if dirs then @directories.filter (dir)-> (dirs.indexOf(dir.leafName) >=0) else @directories
    cmd = "#{args}" or "status"
    fn = @_call.bind this, cmd

    dirs.forEach fn
  _call: (command, dir)->
    _cwd = io.cwd
    try
      io.cwd = dir.path
      output = io.system "git #{command}"
    catch error
      output = error
    dactyl.echomsg "OCTOPUS: #{dir.leafName.toUpperCase()} >> #{output}"
    io.cwd = _cwd



#DECLARE PLUGIN
group.commands.add ["pundle", "pud"], pundle.info.description, (args)->
  pundle.execute(args)
,{
  literal: 0
  options: [{
    names: ["-directories","-D"]
    description: "Select specific directories"
    type: CommandOption.LIST
    completer: bundles.map (dir)-> [dir.leafName, dir.path]
  }]
}
