class SensorAgent < Agent
  agent_name '场景控制'
  agent_desc '控制场景的开关，颜色，亮度等'

  on_call_with_final_result do
    "好的，已经为你完成了对应的操作"
  end
end