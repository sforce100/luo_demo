# frozen_string_literal: true

require_relative 'init'

## 测试时只需要修改:
# 1. prompt模版参数
# 2. 测试数据 user_input
# 3. 对话历史保存的次数 max_history

prompt = Prompts.hello_xinghuo
user_input =  "打开灯"


messages = Messages.create().user(prompt: prompt, context: {user_input:user_input})
# 请求openai返回数据
response = OpenAI.new.chat(messages)
# 打印响应结果
Helpers.print_md response
