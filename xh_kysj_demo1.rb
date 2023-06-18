# frozen_string_literal: true

require_relative 'init'

prompt = Prompts.kysj_demo1

result = []

File.open("filename-t1.txt", "w") do |file|
  30.times.each do |i|
    messages = Messages.create().user(prompt: prompt, context: {})
    puts "========================================================"
  
    # 请求星火返回数据
    response = Xinghuo.new.chat(messages)
  
    # reply = ""
    # response.split("\n").each do |line|
    #   if line =~ /^【Spark】/
    #     reply = line.gsub(/^【Spark】\s*(:|：)*/, "")
    #   end
    # end
    # Helpers.print_md reply
    reply = response
    puts reply
    file.write("#{response}\n\n\n")
    result << reply
  end
end

puts "count: #{result.uniq.count}"