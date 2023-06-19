# frozen_string_literal: true

require_relative 'init'


LEVEL_RULE = {
  "1" => "只用中国小学2年级及以下的词汇，每个句子不要超过10个单词；",
  "2" => "只用中国小学4年级以下的词汇，不要使用各种时态，不使用复杂句式；",
  "3" => "只用中国小学阶段及以下的词汇，不要使用各种时态，不要用复杂句式；",
  "4" => "只用中国小学阶段及以下的词汇，可以用各种时态，不要用复杂句式；",
  "5" => "只用中国初中阶段及以下的词汇，可以用各种时态，可以用简单从句；",
  "6" => "只用中国初中阶段及以下的词汇，可以用各种时态，可以用简单从句，可以用倒装句；",
  "7" => "只用中国初中3年级以下的词汇，可以用倒装句等复杂的句式；",
  "8" => "只使用中国高中阶段及以下的词汇及其变形词；可以用倒装句等复杂的句式；",
  "9" => "可以少量使用高级词汇；无其他限制；可以用倒装句等复杂的句式；",
  "10" => "可以大量使用高级词汇；无其他限制；可以用倒装句等复杂的句式；"
}

def prints(file, text)
  tt = text+"\n"
  file.write(tt)
  puts tt
end


xh_prompt = Prompts.kysj_xh
openai_prompt = Prompts.kysj_openai1
user_name = "Tom"
spark_name = "Spark"
origin_response_file = File.open("./test_history/kysj_chating_origin.txt", "w")
File.open("./test_history/kysj_chating.txt", "w") do |file|
  [
    {topic: 'introduce', level: 1, times: 5, welcome: "Hi, I'm Spark, what's your name?"},
    {topic: 'sports', level: 2, times: 5, welcome: "Hey,<%name>,  what sports do you like?"},
    {topic: 'family', level: 3, times: 5, welcome: "<%name>, tell me about a fun thing you did with your family recently."},
    {topic: 'hometown', level: 4, times: 8, welcome: "Hey,<%name>, where are you from?"},
    {topic: 'friends', level: 5, times: 8, welcome: "Hey,<%name>, can you introduce your best friend to me?"},
    {topic: 'famous people', level: 6, times: 8, welcome: "Hi, <%name>, let's talk about anyone famous!"},
    {topic: 'team work', level: 7, times: 10, welcome: "<%name>, do you prefer team sports or individual ones?"},
    {topic: 'technology', level: 8, times: 10, welcome: "Have you seen the robots at the science museum? They're so interesting!"},
    {topic: 'interests', level: 9, times: 15, welcome: "I like learning new things, <%name>. What do you like to learn about?"},
    {topic: 'jobs', level: 10, times: 15, welcome: "Jobs can be fun too! Do you enjoy doing any activities at school that could lead to a future career?"},
  ].each do |data|
    topic = data[:topic]
    welcome = data[:welcome].gsub("<%name>", user_name)
    level = data[:level]
    origin_response_file.write("===============>>> topic #{topic}\n")
    prints(file, "===========================================\n")
    prints(file, "===============>>> topic #{topic}\n, level #{level} \n")
    prints(file, "Spark: #{welcome}\n ")
    histories = ["#{spark_name}: #{welcome}"]
    data[:times].times.each do |i|
      begin
        prints(file, "===========================================\n")
        messages = Messages.create().system(prompt: openai_prompt, context: {histories: histories.join("\n"), user_name: user_name, topic: topic, rule: LEVEL_RULE["#{level}"], level: level})
        histories.each do |h|
          if h.match(/^Spark:/i)
            messages.user(text: h.gsub(/^Spark:/i, ""))
          else
            messages.assistant(text: h.gsub(/^Tom:/i, ""))
          end
        end
        # messages = Messages.create().system(text: "你是我的语言伙伴，我想与您进行关于#{topic}的随意对话，帮助我提高英语技能。").user(prompt: openai_prompt, context: {histories: histories.join("\n"), user_name: user_name, topic: topic, rule: LEVEL_RULE["#{level}"]})
        # messages = Messages.create().user(prompt: openai_prompt, context: {histories: histories.join("\n"), user_name: user_name, topic: topic, rule: LEVEL_RULE["#{level}"]})
        openai_response = OpenAI.new.chat(messages)
        response = openai_response.gsub(/^Tom:/i, "").gsub(/^【对话输出】\s*(:|：)*/, "")
        prints(file, "openai: #{response}")
        histories << "#{user_name}: #{response}"
  
       
        xh_response = "是"
        while xh_response.match(/[\u4e00-\u9fa5]/)
          messages = Messages.create().user(prompt: xh_prompt, context: {histories: histories.join("\n"), user_name: user_name, topic: topic, rule: LEVEL_RULE["#{level}"]})
          xh_response = Xinghuo.new.chat(messages)
          if !xh_response.match(/[\u4e00-\u9fa5]/)
            response = xh_response.split("\n")[0].gsub(/^Spark:/i, "").gsub(/^【Spark】\s*(:|：)*/, "")
            if response.match(/[a-zA-Z]+/)
              prints(file, "spark: #{response}")
              histories << "#{spark_name}: #{response}"
            else
              xh_response = "是"
            end
          end
        end
        
  
        origin_response_file.write("#{openai_response}\n")
        origin_response_file.write("#{xh_response}\n\n\n")
      rescue => exception
        puts exception.message
      end
    end
    prints(file, "\n\n\n")
  end
end

origin_response_file.close