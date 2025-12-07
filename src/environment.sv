class environment extends uvm_env;

  scoreboard     scb;
  subscriber     sub;       
  passive_agent  p_agent;
  active_agent   a_agent;

  `uvm_component_utils(environment)
  
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Set active/passive
    uvm_config_db#(uvm_active_passive_enum)::set(this, "a_agent", "is_active", UVM_ACTIVE);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "p_agent", "is_active", UVM_PASSIVE);

    scb     = scoreboard   ::type_id::create("scb", this);
    sub     = subscriber   ::type_id::create("sub", this);   
    p_agent = passive_agent::type_id::create("p_agent", this);
    a_agent = active_agent ::type_id::create("a_agent", this);

  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    // ================= ACTIVE MONITOR CONNECTIONS =================//

    // Active monitor to Coverage subscriber
    a_agent.a_mon_h.send_port.connect(sub.cov_active_mon_port);

    // Active monitor → Scoreboard EXPECTED FIFO
    a_agent.a_mon_h.send_port.connect(scb.expected_fifo.analysis_export);

    // ================= PASSIVE MONITOR CONNECTIONS =================//

    // passive monitor to subscriber
    p_agent.p_mon_h.send_port.connect(sub.cov_passive_mon_port);

    // passive monitor → scoreboard ACTUAL FIFO
    p_agent.p_mon_h.send_port.connect(scb.actual_fifo.analysis_export);

  endfunction

endclass

