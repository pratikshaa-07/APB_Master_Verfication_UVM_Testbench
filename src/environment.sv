class environment extends uvm_env;
  scoreboard scb;
 // subscriber sub;
  passive_agent p_agent;
  active_agent a_agent;
  `uvm_component_utils(environment)
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
  endfunction
  
function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  // IMPORTANT — path must be STRING
  uvm_config_db#(uvm_active_passive_enum)::set(this, "a_agent", "is_active", UVM_ACTIVE);
  uvm_config_db#(uvm_active_passive_enum)::set(this, "p_agent", "is_active", UVM_PASSIVE);

  scb     = scoreboard::type_id::create("scb", this);
  p_agent = passive_agent::type_id::create("p_agent", this);
  a_agent = active_agent::type_id::create("a_agent", this);
endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
     //active monitor to fifo
   //    a_agent.a_mon.connect(sub.a_mon.analysis_export);
    a_agent.a_mon_h.send_port.connect(scb.expected_fifo.analysis_export);

       //passive monitor to fifo
    //     p_agent.p_mon.connect(sub.p_mon.analysis_export);
    p_agent.p_mon_h.send_port.connect(scb.actual_fifo.analysis_export);

    
  endfunction
endclass
