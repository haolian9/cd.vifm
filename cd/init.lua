do
  local uid = assert(os.getenv("UID") or os.getenv("USER"), "unable to find out your uid")
  local in_tmux = os.getenv("TMUX") ~= nil

  ---@param category string
  ---@return string
  local function resolve_outfile(category) return string.format("/tmp/%s-vifm-%s", uid, category) end

  ---@param script string
  ---@return string
  local function script_path(script) return string.format("%s/scripts/%s", vifm.plugin.path, script) end

  local function goto_chosen_dir(curview, outfile)
    local file = assert(io.open(outfile, "r"))
    local chosen_dir = file:read("*a")
    assert(chosen_dir ~= "")
    file:close()
    curview:cd(chosen_dir)
  end

  local function fd(info)
    assert(in_tmux)
    local _ = info
    local outfile = resolve_outfile("fd")
    local curview = vifm.currview()
    local cmd = string.format("tmux display-popup -E %s --working-dir='%s' --out-file='%s'", script_path("fd.py"), curview.cwd, outfile)
    vifm.startjob({
      cmd = cmd,
      ---@param job VifmJob
      onexit = function(job)
        local rc = job:exitcode()
        if rc ~= 0 then return vifm.sb.error(string.format("fd.py rc=%d", rc)) end
        goto_chosen_dir(curview, outfile)
      end,
    })
  end

  local function zd(info)
    local _ = info
    local outfile = resolve_outfile("zd")
    local curview = vifm.currview()
    local cmd = string.format("%s --out-file='%s'", script_path("zd.py"), outfile)
    local rc = vifm.run({ cmd = cmd })
    if rc ~= 0 then return vifm.sb.error(string.format("zd.py rc=%d", rc)) end
    goto_chosen_dir(curview, outfile)
  end

  assert(vifm.cmds.add({ name = "fd", maxargs = 0, handler = fd }))
  assert(vifm.cmds.add({ name = "zd", maxargs = 0, handler = zd }))
end

return {}
