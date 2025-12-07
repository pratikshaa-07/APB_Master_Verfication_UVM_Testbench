class passive_monitor extends uvm_monitor;
  
  virtual intf vif;
  seq_item req;
  
  uvm_analysis_port#(seq_item) send_pport;
  
  `uvm_component_utils(passive_monitor)
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
    send_pport = new("send_pport", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
      `uvm_fatal("MONITOR-VIF","virtual interface not set");  
  endfunction
  
  task monitor();
    send_to_inf();
    repeat(1) @(vif.mon_cb);
  endtask
  
  task send_to_inf();
    req = seq_item::type_id::create("req");

    req.PADDR         = vif.mon_cb.PADDR;
    req.PSEL          = vif.mon_cb.PSEL;
    req.PENABLE       = vif.mon_cb.PENABLE;
    req.PWRITE        = vif.mon_cb.PWRITE;
    req.PWDATA        = vif.mon_cb.PWDATA;
    req.PSTRB         = vif.mon_cb.PSTRB;
    req.rdata_out     = vif.mon_cb.rdata_out;
    req.transfer_done = vif.mon_cb.transfer_done;
    req.error         = vif.mon_cb.error;
    `uvm_info("PASSIVE-MONITOR", $sformatf("Got paddr=%0d psel=%0d penable=%0d pwrite=%0d pwdata=%0d pstrb=%0d rdata_out = %0d transfer_done=%0d error=%0d",req.PADDR,req.PSEL,req.PENABLE,req.PWRITE,req.PWDATA,req.PSTRB,req.rdata_out,req.transfer_done,req.error), UVM_LOW)

    send_pport.write(req);
      
  endtask
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    repeat(4) @(vif.mon_cb);
    forever 
      begin
      monitor();
    end
  endtask
  
endclass

