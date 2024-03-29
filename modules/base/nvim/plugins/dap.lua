local dap, dapui = require "dap", require "dapui"

local sign = vim.fn.sign_define
sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

dapui.setup {} -- use default
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

local dap_python = require "dap-python"

dap_python.setup(vim.g.python3_host_prog)
dap_python.test_runner = 'pytest'
table.insert(dap.configurations.python, {
  type = "python",
  request = "attach",
  connect = {
    port = 5678,
    host = "127.0.0.1",
  },
  mode = "remote",
  name = "Container Attach Debug",
  cwd = vim.fn.getcwd(),
  pathMappings = {
    {
      localRoot = function()
        return vim.fn.input("Local code folder > ", vim.fn.getcwd(), "file")
      end,
      remoteRoot = function()
        return vim.fn.input("Container code folder > ", "/", "file")
      end,
    },
  },
})

require('dap-go').setup()
require('nvim-dap-virtual-text').setup()

dap.listeners.before['event_progressStart']['progress-notifications'] = function(session, body)
  local notif_data = get_notif_data("dap", body.progressId)

  local message = format_message(body.message, body.percentage)
  notif_data.notification = vim.notify(message, "info", {
    title = format_title(body.title, session.config.type),
    icon = spinner_frames[1],
    timeout = false,
    hide_from_history = false,
  })

  notif_data.notification.spinner = 1
  update_spinner("dap", body.progressId)
end

dap.listeners.before['event_progressUpdate']['progress-notifications'] = function(session, body)
  local notif_data = get_notif_data("dap", body.progressId)
  notif_data.notification = vim.notify(format_message(body.message, body.percentage), "info", {
    replace = notif_data.notification,
    hide_from_history = false,
  })
end

dap.listeners.before['event_progressEnd']['progress-notifications'] = function(session, body)
  local notif_data = client_notifs["dap"][body.progressId]
  notif_data.notification = vim.notify(body.message and format_message(body.message) or "Complete", "info", {
    icon = "",
    replace = notif_data.notification,
    timeout = 2000
  })
  notif_data.spinner = nil
end
