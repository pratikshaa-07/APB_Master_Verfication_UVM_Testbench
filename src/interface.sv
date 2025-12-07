//`include "uvm_macros.svh"

interface intf(input bit PCLK);

  // input signals (from TB to DUT)
  bit PRESET_n;
  bit transfer;
  bit PSLVERR;
  bit write_read;
  bit [7:0]  addr_in;
  bit [31:0] wdata_in;
  bit [31:0] PRDATA;
  bit        PREADY;
  bit [3:0]  strb_in;

  // output signals (from DUT to TB)
  logic PSEL;
  logic [3:0] PSTRB;
  logic [31:0] PWDATA;
  logic [7:0]  PADDR;
  logic PWRITE;
  logic PENABLE;
  logic error;
  logic transfer_done;
  logic [31:0] rdata_out;

  //=========================
  // DRIVER CLOCKING BLOCK
  //=========================
  clocking drv_cb @(posedge PCLK);
    default input #0 output #0; //very importatnt !!!

    // DUT outputs driver inputs
    input  PWRITE, PADDR, PENABLE, PWDATA, PSEL,
           error, transfer_done, rdata_out, PSTRB;

    // Driver output
    output PRESET_n, PSLVERR, PRDATA, PREADY,
           transfer, write_read, addr_in, wdata_in, strb_in;
  endclocking

  //=========================
  // MONITOR CLOCKING BLOCK
  //=========================
  clocking mon_cb @(posedge PCLK);
    default input #0 output #0;

    input PWRITE, PADDR, PENABLE, PWDATA, PSEL, error,
          transfer_done, rdata_out, PSTRB,
          PRESET_n, PSLVERR, PRDATA, PREADY,
          transfer, write_read, addr_in, wdata_in, strb_in;
  endclocking

  //=========================
  // MODPORTS
  //=========================
  modport DRV(clocking drv_cb);
  modport MON(clocking mon_cb);

endinterface

