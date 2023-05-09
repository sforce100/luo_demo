class LightAgent < Agent
  agent_name '灯光控制'
  agent_desc '控制灯光的开关，颜色，亮度等'

  on_call_with_final_result do
    "好的，已经为你完成了灯光对应的操作"
  end
end