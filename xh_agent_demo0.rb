require_relative 'init'

## 测试时只需要修改:
# 1. 测试数据 user_input
# 2. SmartHomeAgentRunner 的工具注册 register

user_input =  "打开灯"

# 定义Runner
class SmartHomeAgentRunner < XinghuoAgentRunner
  register LightAgent
end


# 执行
runner = SmartHomeAgentRunner.new
context = runner.call(user_input)

# 打印结果
Helpers.print_md <<~MD
## Response:
#{context.response}

## Final Result:
#{context.final_result}

## History:
```ruby
#{context.histories.to_a}
```
MD

