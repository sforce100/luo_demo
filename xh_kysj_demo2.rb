# frozen_string_literal: true

require_relative 'init'

prompt = Prompts.kysj_demo1

result = []

prompt = <<~EOF
你叫Spark，是一个专业英文口语陪练。我的名字叫James Bond。
你需要根据我们的对话给出一句英文回复，你需要严格按照一下规则：
1. 只需要回复一句英文。
2. 对话需要围绕animals。
3. 内容不要和对话记录重复。
4. 只用中国小学阶段及以下的词汇，不要使用各种时态，不要用复杂句式；
EOF

histories = MemoryHistory.new(30)
histories.user(prompt)
histories.assistant("Hi James Bond,  Do you like animals?")
histories.user("I don't like animals.")
histories.assistant("Oh, I see. Maybe you don't like them because they can be scary or hurtful sometimes. But some animals are really cute and friendly, like cats and dogs. Have you ever seen a panda? They're so adorable!")
histories.user("Yes you are right. But I like chicken chicken is delicious.")
File.open("filename1-1.txt", "w") do |file|
  30.times.each do |i|
    messages = Messages.create(history: histories)
    puts "========================================================"
    # 请求星火返回数据
    response = Xinghuo.new.chat(messages)
  
    Helpers.print_md response
    file.write("#{response}\n\n\n")
    result << response
  end
end

puts "count: #{result.uniq.count}"
