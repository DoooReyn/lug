--
-- Author: Reyn
-- Date: 2017-09-02 02:05:00
--
--[[
  日志模块，用于对四类信息分别进行记录
  d    Debug  
  i    Info  
  w    Warn  
  e    Error  
--]]

local function newlog(logbasename)
	local loglevel = {["e"]="error", ["w"]="warn", ["i"]="info", ["d"]="debug"}
	local createtime = os.date("%Y%m%d_%H%M%S", os.time())
	local logfname = logbasename..createtime..".log"

	local f = io.open(logfname, "a+")
	local head = logfname.." begin:\n"
	print(head)
	f:write(head)
	f:flush()

	local function log(level, msg)
		local l   = loglevel[level] or loglevel.i
		local rt  = tostring(os.date("%H:%M:%S", os.time()))
		local out = string.format("\n<<<[%s-%s]\n%s\n>>>[%s-%s]\n", l, rt, msg, l, rt)
		-- if g_IsDebug then print(out) end
		if nil    == f then
			print("logfile: "..logfname.." is close")
			return nil
		end
		f:write(out)
		f:flush()
		return out
	end

	return {
		--记录错误信息　 
		e = function(msg)
			return log('e', msg)
		end, 
		
		--记录警告信息 
		w = function(msg)
			return log('w', msg)
		end, 
		
		--记录有用信息，如需要提取的信息  
		i = function(msg)
			return log('i', msg)
		end, 
		
		--输出debug信息　 
		d = function(msg)
			return log('d', msg)
		end, 
		
		--关闭日志系统  
		close = function()
			f:close()
			f = nil
		end, 

		--路径
		name = function()
			return logfname
		end,
	}
end

local _m = class("lug", {version = "0.1.0"})

function _m:ctor()
	self.logger = newlog(cc.FileUtils:getInstance():getWritablePath())
end

local function _format(fmt, ...)
	local len = select("#", ···)
	local msg = len == 0 and fmt or string.format(fmt, ...)
	return msg
end

function _m:e(fmt, ...)
	self.logger.e(_format(fmt, ...))
end

function _m:w(fmt, ...)
	self.logger.w(_format(fmt, ...))
end

function _m:i(fmt, ...)
	self.logger.i(_format(fmt, ...))
end

function _m:d(fmt, ...)
	self.logger.d(_format(fmt, ...))
end

function _m:name()
	return self.logger:name()
end

return _m
