local _0_0 = nil
do
  local name_0_ = "conjure.client.racket.stdio"
  local module_0_ = nil
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("conjure.aniseed.core"), require("conjure.client"), require("conjure.config"), require("conjure.log"), require("conjure.mapping"), require("conjure.aniseed.nvim"), require("conjure.remote.stdio"), require("conjure.aniseed.string"), require("conjure.text")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {["conjure.macros"] = true}, require = {a = "conjure.aniseed.core", client = "conjure.client", config = "conjure.config", log = "conjure.log", mapping = "conjure.mapping", nvim = "conjure.aniseed.nvim", stdio = "conjure.remote.stdio", str = "conjure.aniseed.string", text = "conjure.text"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local client = _local_0_[2]
local config = _local_0_[3]
local log = _local_0_[4]
local mapping = _local_0_[5]
local nvim = _local_0_[6]
local stdio = _local_0_[7]
local str = _local_0_[8]
local text = _local_0_[9]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "conjure.client.racket.stdio"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
config.merge({client = {racket = {stdio = {["prompt-pattern"] = "\n?[\"%w%-./_]*> ", command = "racket", mapping = {start = "cs", stop = "cS"}}}}})
local cfg = nil
do
  local v_0_ = config["get-in-fn"]({"client", "racket", "stdio"})
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["cfg"] = v_0_
  cfg = v_0_
end
local state = nil
do
  local v_0_ = nil
  local function _2_()
    return {repl = nil}
  end
  v_0_ = (((_0_0)["aniseed/locals"]).state or client["new-state"](_2_))
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["state"] = v_0_
  state = v_0_
end
local buf_suffix = nil
do
  local v_0_ = nil
  do
    local v_0_0 = ".rkt"
    _0_0["buf-suffix"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["buf-suffix"] = v_0_
  buf_suffix = v_0_
end
local comment_prefix = nil
do
  local v_0_ = nil
  do
    local v_0_0 = "; "
    _0_0["comment-prefix"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["comment-prefix"] = v_0_
  comment_prefix = v_0_
end
local context_pattern = nil
do
  local v_0_ = nil
  do
    local v_0_0 = "%(%s*module%s+(.-)[%s){]"
    _0_0["context-pattern"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["context-pattern"] = v_0_
  context_pattern = v_0_
end
local with_repl_or_warn = nil
do
  local v_0_ = nil
  local function with_repl_or_warn0(f, opts)
    local repl = state("repl")
    if repl then
      return f(repl)
    else
      return log.append({(comment_prefix .. "No REPL running")})
    end
  end
  v_0_ = with_repl_or_warn0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["with-repl-or-warn"] = v_0_
  with_repl_or_warn = v_0_
end
local format_message = nil
do
  local v_0_ = nil
  local function format_message0(msg)
    return str.split((msg.out or msg.err), "\n")
  end
  v_0_ = format_message0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["format-message"] = v_0_
  format_message = v_0_
end
local display_result = nil
do
  local v_0_ = nil
  local function display_result0(msg)
    local function _2_(_241)
      return not ("" == _241)
    end
    return log.append(a.filter(_2_, format_message(msg)))
  end
  v_0_ = display_result0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["display-result"] = v_0_
  display_result = v_0_
end
local prep_code = nil
do
  local v_0_ = nil
  local function prep_code0(s)
    local lang_line_pat = "#lang [^%s]+"
    local code = nil
    if s:match(lang_line_pat) then
      log.append({(comment_prefix .. "Dropping #lang, only supported in file evaluation.")})
      code = s:gsub(lang_line_pat, "")
    else
      code = s
    end
    return (code .. "\n(flush-output)")
  end
  v_0_ = prep_code0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["prep-code"] = v_0_
  prep_code = v_0_
end
local eval_str = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function eval_str0(opts)
      local function _2_(repl)
        local function _3_(msgs)
          if ((1 == a.count(msgs)) and ("" == a["get-in"](msgs, {1, "out"}))) then
            a["assoc-in"](msgs, {1, "out"}, (comment_prefix .. "Empty result."))
          end
          opts["on-result"](str.join("\n", format_message(a.last(msgs))))
          return a["run!"](display_result, msgs)
        end
        return repl.send(prep_code(opts.code), _3_, {["batch?"] = true})
      end
      return with_repl_or_warn(_2_)
    end
    v_0_0 = eval_str0
    _0_0["eval-str"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["eval-str"] = v_0_
  eval_str = v_0_
end
local eval_file = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function eval_file0(opts)
      return eval_str(a.assoc(opts, "code", (",require-reloadable " .. opts["file-path"])))
    end
    v_0_0 = eval_file0
    _0_0["eval-file"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["eval-file"] = v_0_
  eval_file = v_0_
end
local doc_str = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function doc_str0(opts)
      local function _2_(_241)
        return (",doc " .. _241)
      end
      return eval_str(a.update(opts, "code", _2_))
    end
    v_0_0 = doc_str0
    _0_0["doc-str"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["doc-str"] = v_0_
  doc_str = v_0_
end
local display_repl_status = nil
do
  local v_0_ = nil
  local function display_repl_status0(status)
    local repl = state("repl")
    if repl then
      return log.append({(comment_prefix .. a["pr-str"](a["get-in"](repl, {"opts", "cmd"})) .. " (" .. status .. ")")}, {["break?"] = true})
    end
  end
  v_0_ = display_repl_status0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["display-repl-status"] = v_0_
  display_repl_status = v_0_
end
local stop = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function stop0()
      local repl = state("repl")
      if repl then
        repl.destroy()
        display_repl_status("stopped")
        return a.assoc(state(), "repl", nil)
      end
    end
    v_0_0 = stop0
    _0_0["stop"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["stop"] = v_0_
  stop = v_0_
end
local enter = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function enter0()
      local repl = state("repl")
      local path = nvim.fn.expand("%:p")
      if (repl and not log["log-buf?"](path)) then
        local function _2_()
        end
        return repl.send(prep_code((",enter " .. path)), _2_)
      end
    end
    v_0_0 = enter0
    _0_0["enter"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["enter"] = v_0_
  enter = v_0_
end
local start = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function start0()
      if state("repl") then
        return log.append({"; Can't start, REPL is already running.", ("; Stop the REPL with " .. config["get-in"]({"mapping", "prefix"}) .. cfg({"mapping", "stop"}))}, {["break?"] = true})
      else
        local function _2_(err)
          return display_repl_status(err)
        end
        local function _3_(code, signal)
          if (("number" == type(code)) and (code > 0)) then
            log.append({(comment_prefix .. "process exited with code " .. code)})
          end
          if (("number" == type(signal)) and (signal > 0)) then
            log.append({(comment_prefix .. "process exited with signal " .. signal)})
          end
          return stop()
        end
        local function _4_(msg)
          return display_result(msg)
        end
        local function _5_()
          display_repl_status("started")
          return enter()
        end
        return a.assoc(state(), "repl", stdio.start({["on-error"] = _2_, ["on-exit"] = _3_, ["on-stray-output"] = _4_, ["on-success"] = _5_, ["prompt-pattern"] = cfg({"prompt-pattern"}), cmd = cfg({"command"})}))
      end
    end
    v_0_0 = start0
    _0_0["start"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["start"] = v_0_
  start = v_0_
end
local on_load = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function on_load0()
      do
        nvim.ex.augroup("conjure-racket-stdio-bufenter")
        nvim.ex.autocmd_()
        nvim.ex.autocmd("BufEnter", ("*" .. buf_suffix), ("lua require('" .. _2amodule_name_2a .. "')['" .. "enter" .. "']()"))
        nvim.ex.augroup("END")
      end
      return start()
    end
    v_0_0 = on_load0
    _0_0["on-load"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["on-load"] = v_0_
  on_load = v_0_
end
local on_filetype = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function on_filetype0()
      mapping.buf("n", "RktStart", cfg({"mapping", "start"}), _2amodule_name_2a, "start")
      return mapping.buf("n", "RktStop", cfg({"mapping", "stop"}), _2amodule_name_2a, "stop")
    end
    v_0_0 = on_filetype0
    _0_0["on-filetype"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["on-filetype"] = v_0_
  on_filetype = v_0_
end
local on_exit = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function on_exit0()
      return stop()
    end
    v_0_0 = on_exit0
    _0_0["on-exit"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["on-exit"] = v_0_
  on_exit = v_0_
end
return nil