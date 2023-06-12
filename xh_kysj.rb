# frozen_string_literal: true

require_relative 'init'


## 测试时只需要修改:
# 1. prompt模版参数
# 2. 测试数据集test3.yml
# 3. 对话历史保存的次数 max_history

max_history = 12
prompt = Prompts.kysj
test_file = 'test_data/kysj.yml'


histories = MemoryHistory.new(max_history)

user_name="tom"
rule="只用中国初中阶段及以下的词汇，可以用各种时态，可以用简单从句;"
topic="animal"
Helpers.load_test(test_file) do |input|
  messages = Messages.create(history: histories).user(prompt: prompt, context: {user_input: input, sentence_rule: rule, talk_topic: topic, user_name: user_name})

  puts "========================================================"
  puts messages.to_a

  # 请求星火返回数据
  response = Xinghuo.new.chat(messages)
  
  # 打印响应结果
  Helpers.print_md response

  reply = ""
  response.split("\n").each do |line|
    if line =~ /^【Spark回复】/
      reply = line.gsub(/^【Spark回复】\s*(:|：)*/, "")
    end
  end
  
  # 记录历史
  histories.user(input)
  histories.assistant(reply)
end