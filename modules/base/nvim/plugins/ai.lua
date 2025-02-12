local _, codecompanion = pcall(require, "codecompanion")

local OllamaState = {
  ANTICIPATING_REASONING = 1,
  REASONING = 2,
  ANTICIPATING_OUTPUTTING = 3,
  OUTPUTTING = 4,
}
---@type integer
local _ollama_state


codecompanion.setup({
  display = {
    diff = {
      provider = "mini_diff",
    },
  },
  adapters = {
    ollama = function()
      local ollama = require("codecompanion.adapters.ollama")
      return require("codecompanion.adapters").extend("ollama", {
        name = "ollama",
        schema = {
          model = {
            default = "qwen2.5-coder:32b",
          },
        },
        ---Check for a token before starting the request
        ---@param self CodeCompanion.Adapter
        ---@return boolean
        setup = function(self)
          _ollama_state = OllamaState.ANTICIPATING_OUTPUTTING
          return true
        end,
        handlers = {
          chat_output = function(self, data)
            local inner = ollama.handlers.chat_output(self, data)

            if inner == nil then
              return inner
            end

            if inner.status ~= "success" or inner.output == nil or type(inner.output.content) ~= "string" then
              return inner
            end

            if string.find(inner.output.content, "<think>") ~= nil then
              _ollama_state = OllamaState.ANTICIPATING_REASONING
              inner.output.content = inner.output.content:gsub("%s*<think>%s*", "")
            elseif string.find(inner.output.content, "</think>") ~= nil then
              _ollama_state = OllamaState.ANTICIPATING_OUTPUTTING
              inner.output.content = inner.output.content:gsub("%s*</think>%s*", "")
            elseif inner.output.content:match("^%s*$") ~= nil then
              inner.output.content = ""
            elseif _ollama_state == OllamaState.ANTICIPATING_OUTPUTTING then
              _ollama_state = OllamaState.OUTPUTTING
            elseif _ollama_state == OllamaState.ANTICIPATING_REASONING then
              _ollama_state = OllamaState.REASONING
            end

            if _ollama_state == OllamaState.ANTICIPATING_REASONING or _ollama_state == OllamaState.REASONING then
              inner.output.reasoning = inner.output.content
              inner.output.content = nil
            end

            return inner
          end,
        },
      })
    end,
  },
  strategies = {
    chat = {
      adapter = "ollama",
    },
    inline = {
      adapter = "ollama",
    },
    agent = {
      adapter = "ollama",
    },
  },
})
