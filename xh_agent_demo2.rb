require_relative 'init'

## 测试时只需要修改:
# 1. 测试数据集合 test_file
# 2. SmartHomeAgentRunner 的工具注册 register


test_file = 'test_data/smart_home_test.yml'


#########  定义Runner   ########
class SmartHomeAgentRunner < XinghuoAgentRunner
  register LightAgent
  register SensorAgent
  register FinalAgent
end

class Runner < XinghuoAgentRunner
  register WeatherAgent
  register TimeAgent
  register SmartHomeAgent
end


runner = Runner.new

# 加载测试数据集，有需要可以修改 test2.yml
Helpers.load_test(test_file) do |input|
  # 执行
  context = runner.call(input)
  # 打印结果
  Helpers.print_md <<~MD
  ## Input:
  #{input}

  ## Response:
  #{context.response}

  ## Final Result:
  #{context.final_result}

  ## History:
  ```ruby
  #{context.histories.to_a}
  ```
  MD
  puts "\n\n\n"
end

