class passive_agent extends uvm_agent;
  passive_monitor p_mon_h;
  
  `uvm_component_utils(passive_agent)
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active() == UVM_PASSIVE) 
      begin
        p_mon_h=passive_monitor::type_id::create("p_mon_h",this);
      end
  endfunction  
endclass
