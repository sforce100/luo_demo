class FinalAgent < Agent
  agent_name '其他设备控制'
  agent_desc '控制其他设备的开关，颜色，亮度等'

  on_call_with_final_result do
    "好的，已经为你完成了对应的操作"
  end
end