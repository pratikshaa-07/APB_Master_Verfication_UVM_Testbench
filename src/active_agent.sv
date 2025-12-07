class active_agent extends uvm_agent;
  driver drv_h;
  active_monitor a_mon_h;
  sequencer seqr_h;
  
  `uvm_component_utils(active_agent)
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(get_is_active()==UVM_ACTIVE)
      begin
        drv_h=driver::type_id::create("drv_h",this);
        seqr_h=sequencer::type_id::create("seqr_h",this);
      end
    a_mon_h=active_monitor::type_id::create("a_mon_h",this);
  endfunction  
  
  function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
        if(get_is_active() == UVM_ACTIVE) 
          begin
          drv_h.seq_item_port.connect(seqr_h.seq_item_export);
        end
    endfunction
endclass
