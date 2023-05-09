# frozen_string_literal: true

require_relative 'init'


## 测试时只需要修改:
# 1. prompt模版参数
# 2. 测试数据集test3.yml
# 3. 对话历史保存的次数 max_history

max_history = 12
prompt = Prompts.hello_xinghuo
test_file = 'test_data/hello_test.yml'


histories = MemoryHistory.new(max_history)
Helpers.load_test(test_file) do |input|
  messages = Messages.create(History: histories).user(prompt: prompt, context: {user_input: input})

  # 请求星火返回数据
  response = Xinghuo.new.chat(messages)
  
  # 打印响应结果
  Helpers.print_md response

  # 记录历史
  histories.user(input)
  histories.assistant(response)
end