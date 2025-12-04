class scoreboard extends uvm_scoreboard;
  
  // ACTIVE monitor → expected (stimulus)
  uvm_tlm_analysis_fifo#(seq_item) expected_fifo;
  // PASSIVE monitor → actual (DUT output)
  uvm_tlm_analysis_fifo#(seq_item) actual_fifo;
  
  seq_item in_item;
  seq_item op_item; 
  
  int setup_phase, access_phase, extra_phase;
  int pass_count, fail_count;
  
  bit [31:0] stored_wdata;
  bit [7:0]  stored_addr;
  bit [3:0]  stored_strobe;
  bit        stored_rd_wrt;
  
  `uvm_component_utils(scoreboard)
  
  function new(string name="", uvm_component parent);
    super.new(name, parent);
    expected_fifo = new("expected_fifo", this);
    actual_fifo   = new("actual_fifo", this);
  endfunction
  
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      fork
        expected_fifo.get(in_item); // stimulus from active monitor
        actual_fifo.get(op_item);   // output from passive monitor
      join

      // correct argument order:
      assign_expected(op_item, in_item);
    end
  endtask
  
task assign_expected(seq_item actual, seq_item expected);

  //---------------- RESET / NO TRANSFER ----------------//
  if (expected.PRESET_n == 0 || expected.transfer == 0) begin
      
    expected.PADDR         = '0;
    expected.PSEL          = 0;
    expected.PENABLE       = 0;
    expected.PWDATA        = '0;
    expected.PSTRB         = '0;
    expected.rdata_out     = '0;
    expected.transfer_done = '0;
    expected.error         = '0;
      
    extra_phase  = 0;
    setup_phase  = 1;
    access_phase = 0;

    stored_addr   = 0;
    stored_wdata  = 0;
    stored_strobe = 0;
    stored_rd_wrt = 0;

    `uvm_info("SCOREBOARD",
          $sformatf("RESET|NO-TRANSFER [INPUTS]: transfer=%0d reset=%0d strb=%0d wdata=%0d wr_rd=%0d addr=%0d pready=%0d pslverr=%0d prdata=%0d",
                          expected.transfer, expected.PRESET_n, expected.strb_in, expected.wdata_in,
                          expected.write_read, expected.addr_in, expected.PREADY, expected.PSLVERR, expected.PRDATA),
                UVM_LOW)

      `uvm_info("SCOREBOARD",
                $sformatf("RESET|NO-TRANSFER [OUTPUTS]: paddr=%0d psel=%0d penable=%0d pwrite=%0d pwdata=%0d pstrb=%0d rdata=%0d done=%0d error=%0d",
                          actual.PADDR, actual.PSEL, actual.PENABLE, actual.PWRITE,
                          actual.PWDATA, actual.PSTRB, actual.rdata_out, actual.transfer_done, actual.error),
                UVM_LOW)

    // REPORT HERE
    report_result(expected, actual);
    return;
  end


  //---------------- SETUP PHASE ----------------//
  else if (setup_phase == 1 && extra_phase == 0) begin

    if (actual.PSEL != 1) begin
      access_phase = 0;
      setup_phase  = 1;
      extra_phase  = 1;
      $display("PSEL not yet asserted in SETUP PHASE");
    end
    else begin
      access_phase = 1;
      setup_phase  = 0;
      extra_phase  = 0;
    end

    expected.PSEL          = 1;
    expected.PADDR         = expected.addr_in;
    expected.PWRITE        = expected.write_read;
    expected.PENABLE       = 0;
    expected.transfer_done = 0;
    expected.error         = 0;

    if (expected.PWRITE) begin
      stored_rd_wrt        = expected.write_read;
      expected.PWDATA      = expected.wdata_in;
      stored_wdata         = expected.wdata_in;
      expected.PSTRB       = expected.strb_in;
      stored_strobe        = expected.strb_in;
    end
    else begin
      expected.PWDATA = '0;
      expected.PSTRB  = '0;
    end
    `uvm_info("SCOREBOARD",
        $sformatf("SETUP PHASE [INPUTS]: transfer=%0d reset=%0d strb=%0d wdata=%0d wr_rd=%0d addr=%0d pready=%0d pslverr=%0d prdata=%0d",
                  expected.transfer, expected.PRESET_n, expected.strb_in,
                  expected.wdata_in, expected.write_read, expected.addr_in,
                  expected.PREADY, expected.PSLVERR, expected.PRDATA),
        UVM_LOW)

      `uvm_info("SCOREBOARD",
        $sformatf("SETUP PHASE [OUTPUTS]: paddr=%0d psel=%0d penable=%0d pwrite=%0d pwdata=%0d pstrb=%0d rdata=%0d done=%0d error=%0d",
                  actual.PADDR, actual.PSEL, actual.PENABLE, actual.PWRITE,
                  actual.PWDATA, actual.PSTRB, actual.rdata_out,
                  actual.transfer_done, actual.error),
        UVM_LOW)
    // REPORT HERE
    report_result(expected, actual);
    return;
  end


  //---------------- EXTRA SETUP ----------------//
  else if (setup_phase == 1 && extra_phase == 1) begin

    if (actual.PSEL != 1) begin
      access_phase = 0;
      setup_phase  = 1;
      extra_phase  = 1;
      fail_count++;
      $display("PSEL not yet asserted in EXTRA SETUP PHASE");
    end
    else begin
      access_phase = 1;
      setup_phase  = 0;
      extra_phase  = 0;
    end
        `uvm_info("SCOREBOARD",
                  $sformatf("EXTRA PHASE [INPUTS]: transfer=%0d reset=%0d strb=%0d wdata=%0d wr_rd=%0d addr=%0d pready=%0d pslverr=%0d prdata=%0d",
                  expected.transfer, expected.PRESET_n, expected.strb_in,
                  expected.wdata_in, expected.write_read, expected.addr_in,
                  expected.PREADY, expected.PSLVERR, expected.PRDATA),
        UVM_LOW)

      `uvm_info("SCOREBOARD",
                $sformatf("EXTRA PHASE [OUTPUTS]: paddr=%0d psel=%0d penable=%0d pwrite=%0d pwdata=%0d pstrb=%0d rdata=%0d done=%0d error=%0d",
                  actual.PADDR, actual.PSEL, actual.PENABLE, actual.PWRITE,
                  actual.PWDATA, actual.PSTRB, actual.rdata_out,
                  actual.transfer_done, actual.error),
        UVM_LOW)
    // REPORT HERE
    report_result(expected, actual);
    //return;
  end


  //---------------- ACCESS PHASE ----------------//
  else if (access_phase == 1 && extra_phase == 0) begin

    if (expected.PREADY == 1) begin
        
      setup_phase  = 1;
      access_phase = 0;

      expected.transfer_done = 1;
      expected.error         = expected.PSLVERR;
      expected.PENABLE       = 1;
      expected.PSEL          = 1;
      expected.PADDR         = expected.addr_in;

      if (stored_rd_wrt) begin
        expected.write_read = 1;
        expected.PSTRB      = stored_strobe;
        expected.PWDATA     = expected.wdata_in;
        expected.rdata_out  = 0;
      end
      else begin
        expected.write_read = 0;
        expected.PSTRB      = 0;
        expected.PWDATA     = 0;
        expected.rdata_out  = expected.PRDATA;
      end
    end 
    else begin
      expected.transfer_done = 0;
      expected.error         = 0;
      expected.PSEL          = 1;
      expected.PENABLE       = 1;
      expected.PADDR         = expected.addr_in;

      if (stored_rd_wrt) begin
        expected.write_read = 1;
        expected.PSTRB      = stored_strobe;
        expected.PWDATA     = stored_wdata;
        expected.rdata_out  = 0;
      end
      else begin
        expected.write_read = 0;
        expected.PSTRB      = 0;
        expected.PWDATA     = 0;
        expected.rdata_out  = 0;
      end
    end
    
         `uvm_info("SCOREBOARD",
          $sformatf("ACCESS PHASE [INPUTS]: transfer=%0d reset=%0d strb=%0d wdata=%0d wr_rd=%0d addr=%0d pready=%0d pslverr=%0d prdata=%0d",
                    expected.transfer, expected.PRESET_n, expected.strb_in,
                    expected.wdata_in, expected.write_read, expected.addr_in,
                    expected.PREADY, expected.PSLVERR, expected.PRDATA),
          UVM_LOW)

        `uvm_info("SCOREBOARD",
          $sformatf("ACCESS PHASE [OUTPUTS]: paddr=%0d psel=%0d penable=%0d pwrite=%0d pwdata=%0d pstrb=%0d rdata=%0d done=%0d error=%0d",
                    actual.PADDR, actual.PSEL, actual.PENABLE, actual.PWRITE,
                    actual.PWDATA, actual.PSTRB, actual.rdata_out,
                    actual.transfer_done, actual.error),
          UVM_LOW)


    // REPORT HERE
    report_result(expected, actual);
    return;
  end

endtask


  //---------------- COMPARISON ----------------//
  task report_result(seq_item exp, seq_item act);
    bit fail = 0;
    
    if (exp.PADDR != act.PADDR) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("PADDR EXP=%0d ACT=%0d", exp.PADDR, act.PADDR))
    end
    if (exp.PSEL != act.PSEL) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("PSEL EXP=%0d ACT=%0d", exp.PSEL, act.PSEL))
    end
    if (exp.PENABLE != act.PENABLE) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("PENABLE EXP=%0d ACT=%0d", exp.PENABLE, act.PENABLE))
    end
    if (exp.PWRITE != act.PWRITE) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("PWRITE EXP=%0b ACT=%0b", exp.PWRITE, act.PWRITE))
    end
    if (exp.PSTRB != act.PSTRB) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("PSTRB EXP=%0d ACT=%0d", exp.PSTRB, act.PSTRB))
    end
    if (exp.PWDATA != act.PWDATA) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("PWDATA EXP=%0d ACT=%0d", exp.PWDATA, act.PWDATA))
    end
    if (exp.rdata_out != act.rdata_out) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("rdata_out EXP=%0d ACT=%0d", exp.rdata_out, act.rdata_out))
    end
    if (exp.transfer_done != act.transfer_done) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("done EXP=%0d ACT=%0d", exp.transfer_done, act.transfer_done))
    end
    if (exp.error != act.error) begin
      fail = 1;
      `uvm_error("SCOREBOARD", $sformatf("error EXP=%0d ACT=%0d", exp.error, act.error))
    end

    if (!fail) begin
      pass_count++;
      `uvm_info("SCOREBOARD", "PASS", UVM_LOW)
    end
    else begin
      fail_count++;
    end
  endtask


  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info("SCOREBOARD", 
      $sformatf("PASS COUNT : %0d\nFAIL COUNT : %0d", pass_count, fail_count), UVM_LOW)
  endfunction

endclass

