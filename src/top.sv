//import uvm_pkg::*;  
//`include "uvm_pkg.sv"
`include "uvm_macros.svh"
`include "apb_package.sv"
`include "interface.sv"
`include "assertions.sv"
`include "design.sv"

module top;
  
  import uvm_pkg::*;
  import apb_pkg::*;
  
  bit PCLK;
  
  initial PCLK = 0;
  always #5 PCLK = ~PCLK;
  
  intf inf(PCLK);
  
  apb_master #(.ADDR_WIDTH(8), .DATA_WIDTH(32)) u_apb_master (
    .PCLK          (inf.PCLK),
    .PRESETn       (inf.PRESET_n),
    .PADDR         (inf.PADDR),
    .PSEL          (inf.PSEL),
    .PENABLE       (inf.PENABLE),
    .PWRITE        (inf.PWRITE),
    .PWDATA        (inf.PWDATA),
    .PSTRB         (inf.PSTRB),
    .PRDATA        (inf.PRDATA),
    .PREADY        (inf.PREADY),
    .PSLVERR       (inf.PSLVERR),
    .transfer      (inf.transfer),
    .write_read    (inf.write_read),
    .addr_in       (inf.addr_in),
    .wdata_in      (inf.wdata_in),
    .strb_in       (inf.strb_in),
    .rdata_out     (inf.rdata_out),
    .transfer_done (inf.transfer_done),
    .error         (inf.error)
  );
  
  bind inf assertions_apb ASSERT (
    .PCLK          (inf.PCLK),
    .PRESET_n       (inf.PRESET_n),
    .PADDR         (inf.PADDR),
    .PSEL          (inf.PSEL),
    .PENABLE       (inf.PENABLE),
    .PWRITE        (inf.PWRITE),
    .PWDATA        (inf.PWDATA),
    .PSTRB         (inf.PSTRB),
    .PRDATA        (inf.PRDATA),
    .PREADY        (inf.PREADY),
    .PSLVERR       (inf.PSLVERR),
    .transfer      (inf.transfer),
    .write_read    (inf.write_read),
    .addr_in       (inf.addr_in),
    .wdata_in      (inf.wdata_in),
    .strb_in       (inf.strb_in),
    .rdata_out     (inf.rdata_out),
    .transfer_done (inf.transfer_done),
    .error         (inf.error)
  );
  
  initial begin
    uvm_config_db#(virtual intf)::set(null, "*", "vif", inf);
    $dumpfile("dump.vcd");
    $dumpvars;
  end
  
  initial 
    begin
//       run_test("base_test");
//       run_test("pready_1_seq_test");
//       run_test("pready_rand_seq_test");
//       run_test("transfer_rand_seq_test");
//       run_test("rand_seq_test");
//       run_test("mid_reset_1_test");
//       run_test("mid_reset_2_test");
      run_test("regression_test");
    #10;
    $finish;
  end

endmodule

