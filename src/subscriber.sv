`uvm_analysis_imp_decl(_passive_mon_cg)
`uvm_analysis_imp_decl(_active_mon_cg)

class subscriber extends uvm_component;

  `uvm_component_utils(subscriber)

  // analysis import declaration for coverage
  uvm_analysis_imp_active_mon_cg#(seq_item, subscriber) cov_active_mon_port;
  uvm_analysis_imp_passive_mon_cg#(seq_item, subscriber) cov_passive_mon_port;

  seq_item active_mon, passive_mon;

  real active_mon_cov_results, passive_mon_cov_results;

  //------------------------------------------------------//
  //               input covergroup                       //  
  //------------------------------------------------------//
  covergroup input_coverage;
   
    RESET_CP : coverpoint active_mon.PRESET_n;
    PREADY_CP : coverpoint active_mon.PREADY;
    PSLVERR_CP : coverpoint active_mon.PSLVERR;
    transfer_CP : coverpoint active_mon.transfer;
    write_read_CP : coverpoint active_mon.write_read;
    strb_in_CP : coverpoint active_mon.strb_in;
      
    addr_in_CP : coverpoint active_mon.addr_in {
      bins low_0   = {[0:63 ]};
      bins low_1   = {[64:127]};
      bins high_0  = {[128:191]};
      bins high_1  = {[192:255]};
    }

    cross transfer_CP, write_read_CP;
    cross PREADY_CP, transfer_CP;
    cross RESET_CP, transfer_CP;

  endgroup


  //------------------------------------------------------//
  //                 output covergroup                    //  
  //------------------------------------------------------//
  covergroup output_coverage;

    PSEL_CP : coverpoint passive_mon.PSEL;
    PSTRB_CP : coverpoint passive_mon.PSTRB;
    PWRITE_CP : coverpoint passive_mon.PWRITE;
    PENABLE_CP : coverpoint passive_mon.PENABLE;
    ERROR_CP : coverpoint passive_mon.error;
    TRANSFER_DONE_CP : coverpoint passive_mon.transfer_done;

    PWDATA_CP : coverpoint passive_mon.PWDATA {
      bins range_0 = {[32'h0000_0000 : 32'h3333_3333]};
      bins range_1 = {[32'h3333_3334 : 32'h6666_6666]};
      bins range_2 = {[32'h6666_6667 : 32'h9999_9999]};
      bins range_3 = {[32'h9999_999A : 32'hCCCC_CCCC]};
      bins range_4 = {[32'hCCCC_CCCD : 32'hFFFF_FFFF]};
    }
      
    PADDR_CP : coverpoint passive_mon.PADDR {
      bins low_0   = {[0:63 ]};
      bins low_1   = {[64:127]};
      bins high_0  = {[128:191]};
      bins high_1  = {[192:255]};
    }
     
    rdata_out_cp : coverpoint passive_mon.rdata_out {
      bins range0 = {[32'h0000_0000 : 32'h3333_3333]};
      bins range1 = {[32'h3333_3334 : 32'h6666_6666]};
      bins range2 = {[32'h6666_6667 : 32'h9999_9999]};
      bins range3 = {[32'h9999_999A : 32'hCCCC_CCCC]};
      bins range4 = {[32'hCCCC_CCCD : 32'hFFFF_FFFF]};
    }  
      
    cross PSEL_CP, PENABLE_CP {
      ignore_bins invalid_combo1 =
        binsof(PSEL_CP) intersect {0} &&
        binsof(PENABLE_CP) intersect {1};
    }
      
    cross PENABLE_CP, TRANSFER_DONE_CP {
      ignore_bins invalid_combo2 =
        binsof(PENABLE_CP) intersect {0} &&
        binsof(TRANSFER_DONE_CP) intersect {1};
    }

  endgroup


  function new(string name, uvm_component parent);
    super.new(name, parent);
    output_coverage = new();
    input_coverage  = new();
    cov_active_mon_port  = new("cov_active_mon_port", this);
    cov_passive_mon_port = new("cov_passive_mon_port", this);
  endfunction


  function void write_active_mon_cg(seq_item active_mon_seq);
    active_mon = active_mon_seq;
    input_coverage.sample();
  endfunction


  function void write_passive_mon_cg(seq_item passive_mon_seq);
    passive_mon = passive_mon_seq;
    output_coverage.sample();
  endfunction


  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    active_mon_cov_results  = input_coverage.get_coverage();
    passive_mon_cov_results = output_coverage.get_coverage();
  endfunction


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),
      $sformatf("[ACTIVE_MONITOR] Coverage ------> %0.2f%%", active_mon_cov_results),
      UVM_MEDIUM)

    `uvm_info(get_type_name(),
      $sformatf("[PASSIVE_MONITOR] Coverage ------> %0.2f%%", passive_mon_cov_results),
      UVM_MEDIUM)
  endfunction

endclass

