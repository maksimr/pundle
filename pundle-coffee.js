(function() {
  "use strict";
  var Bundle, BundleInstall, BundleRemove, bundleRoot, pundle;

  bundleRoot = io.getRuntimeDirectories("plugins").shift().path;

  Bundle = (function() {

    function Bundle(bundle) {
      var author, dir, name, pack, uri, _i, _len, _ref, _ref2;
      if (!(this instanceof Bundle)) return new Bundle(bundle);
      _ref = Bundle.packages;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        pack = _ref[_i];
        if (pack.name === bundle) return pack;
      }
      bundle = bundle.toString();
      uri = "https://github.com/" + bundle + ".git";
      _ref2 = bundle.split('/'), author = _ref2[0], name = _ref2[1];
      dir = io.getRuntimeDirectories("plugins").shift().child(name);
      this.uri = uri;
      this.path = dir.path;
      this.author = author;
      this.name = name;
      this.instaled = dir.exists();
      Bundle.packages.push(this);
    }

    return Bundle;

  })();

  Bundle.packages = [];

  BundleInstall = function(args) {
    var packName;
    packName = args.toString();
    if (args.bang) {
      return pundle.update(packName);
    } else {
      return pundle.install(packName);
    }
  };

  BundleRemove = function(args) {
    var packName;
    packName = args.toString();
    return pundle.remove(packName);
  };

  pundle = {
    info: {
      version: "0.1",
      description: "Package manager for pentadactyl"
    },
    plugins: dactyl.pluginFiles,
    cmd: {
      INSTALL: "git clone",
      UPDATE: "git pull",
      REMOVE: 'rm -rf'
    },
    install: function(packName) {
      var cmd, log, packages, _cwd;
      packages = packName ? [Bundle(packName)] : Bundle.packages;
      _cwd = io.cwd;
      io.cwd = bundleRoot;
      cmd = this.cmd.INSTALL;
      log = this.log;
      packages.forEach(function(pack) {
        var output;
        if (!pack.instaled) {
          output = pundle.exec(pack, "" + cmd + " " + pack.uri);
          return log(pack.name, output);
        }
      });
      return io.cwd = _cwd;
    },
    update: function(packName) {
      var cmd, log, pack, packages, _cwd;
      packages = packName ? (function() {
        var _i, _len, _ref, _results;
        _ref = Bundle.packages;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          pack = _ref[_i];
          if (pack.name === packName) _results.push(pack);
        }
        return _results;
      })() : Bundle.packages;
      _cwd = io.cwd;
      cmd = this.cmd.UPDATE;
      log = this.log;
      packages.forEach(function(pack) {
        var output;
        if (pack.instaled) {
          io.cwd = pack.path;
          output = pundle.exec(pack, "" + cmd);
          return log(pack.name, output);
        }
      });
      return io.cwd = _cwd;
    },
    remove: function(packName) {
      var cmd, index, output, p, pack, packages, _i, _len;
      packages = Bundle.packages;
      for (_i = 0, _len = packages.length; _i < _len; _i++) {
        p = packages[_i];
        if (p.name === packName) pack = p;
      }
      index = packages.indexOf(pack);
      packages.splice(index, index);
      cmd = "" + this.cmd.REMOVE + " " + pack.path;
      output = pundle.exec(pack, cmd);
      return this.log(pack.name, output);
    },
    exec: function(pack, cmd) {
      var output;
      try {
        output = io.system(cmd);
      } catch (error) {
        output = error;
      }
      return output;
    },
    log: function(spec, output) {
      dactyl.echomsg(" ");
      dactyl.echomsg("$ " + spec);
      return dactyl.echomsg("> " + output);
    },
    completer: function(context) {
      var pack;
      return context.completions = (function() {
        var _i, _len, _ref, _results;
        _ref = Bundle.packages;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          pack = _ref[_i];
          _results.push([pack.name, pack.name]);
        }
        return _results;
      })();
    }
  };

  group.commands.add(["Bundle", "bund"], pundle.info.description, Bundle);

  group.commands.add(["BundleInstall", "bundi"], pundle.info.description, BundleInstall, {
    bang: true,
    completer: function(context, args) {
      if (args.bang) return pundle.completer(context, args);
    }
  });

  group.commands.add(["BundleRemove", "bundr"], pundle.info.description, BundleRemove, {
    literal: 0,
    completer: pundle.completer
  });

}).call(this);
