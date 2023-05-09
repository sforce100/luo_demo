# LUO工具使用说明

## 目录和文件说明
目录： 
templates_backup: 用于存放luo默认prompt请求模版。
templates: 用于存放prompt请求模版，若需要修改默认模版，可以将templates_backup目录下的文件复制到此目录进行修改。另外自定义的prompt文件也是放到此目录，自定义模版使用下文会涉及。
agents: 存放Agent工具，注意Agent工具文件名要与类名一致。
test_data: 存放测试数据集。

默认模版文件：
luo_agent_system.md.erb openai的system内容
luo_agent_input.md.erb openai的user内容
luo_agent_tool_input.md.erb openai的agent模式递归请求的内容
luo_xinghuo_agent_input.md.erb 星火的user内容
luo_xinghuo_response_error.md.erb 星火的agent模式递归请求的内容

** 一般情况下无需修改默认模版文件，除非你想修改agent模式的prompt的请求内容。修改时请注意尖括的内容不能修改（<% xxxxx %>）。 **


## demo 说明
### 简单对话模式
xh_demo0.rb 简单对话模式demo。例子是闲聊的demo prompt。详细说明在文件内有注释说明。
xh_demo1.rb 对话模式demo。多轮次带对话历史。例子是闲聊的demo prompt。详细说明在文件内有注释说明。

### Agent模式
核心模块有两个：Agent 和 Runner, 其中Runner支持星火（XinghuoAgentRunner）和openai（OpenAIAgentRunner）
1. Agent是提供给gpt选择的工具的定义，包含三部分：名称、描述、处理过程。已查询天气的工具为例子。
```
class WeatherAgent < Agent
  # 以下是工具名词
  agent_name '天气查询' 
  # 以下是工具描述
  agent_desc '查询城市的天气情况，穿衣指数，空气质量等' 

  # 以下是工具的处理过程，由于我们已经内置了AIUI的能力，所以凡是需要AIUI的处理能力，以下部分固定不变即可。
  on_call_with_final_result do
    Helpers.print_md "** call aiui weather **"
    messages = Luo::Messages.create.user(text: context.user_input)
    response = Luo::AIUI.new.chat(messages)
    response&.dig("text")
  end
end
```

> 额外说明：如果不使用aiui能力，可以在处理过程直接返回固定文本，例如：

```
class LightAgent < Agent
  agent_name '灯光控制'
  agent_desc '控制灯光的开关，颜色，亮度等'
 
  # 直接返回处理结果文本
  on_call_with_final_result do
    "好的，已经为你完成了灯光对应的操作"
  end
end
```

2. XinghuoAgentRunner 注册并运行agent模式。此处需要两个步骤：注册上文定义的Agent工具、开始运行agent模式。

2.1 注册上文定义的Agent工具
```
class SmartHomeAgentRunner < XinghuoAgentRunner
  register LightAgent
  register WeatherAgent
end
```

2.2 开始运行agent模式，灯带返回结果即可
```
runner = SmartHomeAgentRunner.new
runner.call("帮我打开灯")
```


> 额外说明：如果需要使用openai的Runner，只需要把XinghuoAgentRunner替换为OpenAIAgentRunner
```
class SmartHomeAgentRunner < OpenAIAgentRunner
  register LightAgent
  register WeatherAgent
end
```


### agent模式demo说明:
1. xh_agent_demo0.rb  一个Agent工具，一个XinghuoAgentRunner。
2. xh_agent_demo1.rb  多个个Agent工具，一个XinghuoAgentRunner。
2. xh_agent_demo2.rb  多个个Agent工具，多个XinghuoAgentRunner。XinghuoAgentRunner可以嵌套使用。
4. openai_agent_demo0.rb  一个Agent工具，一个OpenAIAgentRunner。
5. openai_agent_demo1.rb  多个个Agent工具，一个OpenAIAgentRunner。
6. openai_agent_demo2.rb  多个个Agent工具，多个OpenAIAgentRunner。OpenAIAgentRunner可以嵌套使用。


## 环境变量配置
在当前目录下.env文件，运行前请确认环境变量配置正确。
```Bash
OPENAI_ACCESS_TOKEN= # OpenAI的访问令牌
OPENAI_TEMPERATURE= # OpenAI的温度
OPENAI_LIMIT_HISTORY= # OpenAI的历史限制
AIUI_APP_KEY= # AIUI的AppKey
AIUI_APP_ID= # AIUI的AppId
XINGHUO_ACCESS_TOKEN= # 星火大模型的访问令牌
```

## 自建测试目录
若希望创建自己的prompt测试项目，可以执行以下步骤。
1. mkdir demo
2. cd demo
3. luo init
4. 修改 .env 的环境变量
5. ruby application.rb
