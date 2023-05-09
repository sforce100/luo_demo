class SmartHomeAgent < Agent
  agent_name '家居控制'
  agent_desc '控制家里的电器，如：打开空调，关闭空调，打开电视，关闭电视等'

  on_call_with_final_result do
    runner = SmartHomeAgentRunner.new(histories: context.histories.clone)
    response = runner.call(context.user_input).final_result
    actions = response
    Helpers.print_md <<~MD
    ## 输出指令为:
    ```ruby
    #{actions}
    ```
    MD
    "好的，已经为你完成了对应的操作"
  end
end