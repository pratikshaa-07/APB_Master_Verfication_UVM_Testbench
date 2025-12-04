 `include "uvm_macros.svh"
  import uvm_pkg::*;
//`include"morse_defines.sv"
class seq_item extends uvm_sequence_item;
  
  //====================
  // INPUT (rand)
  //====================
  rand bit PRESET_n;
  rand bit transfer;
  rand bit [3:0]  strb_in;
  rand bit [31:0] wdata_in;
  rand bit        write_read;
  rand bit [7:0]  addr_in;
  rand bit        PREADY;
  rand bit        PSLVERR;
  rand bit [31:0] PRDATA;
  
  //====================
  // OUTPUT (logic)
  //====================
  logic [7:0]    PADDR;
  logic          PSEL;
  logic          PENABLE;
  logic          PWRITE;
  logic [31:0]   PWDATA;
  logic [3:0]    PSTRB;
  logic [31:0]   rdata_out;
  logic          transfer_done;
  logic          error;
  
  //====================
  // UVM macros
  //====================
  `uvm_object_utils_begin(seq_item)

    // inputs
    `uvm_field_int(PRESET_n   , UVM_ALL_ON)
    `uvm_field_int(transfer   , UVM_ALL_ON)
    `uvm_field_int(strb_in    , UVM_ALL_ON)
    `uvm_field_int(wdata_in   , UVM_ALL_ON)
    `uvm_field_int(write_read , UVM_ALL_ON)
    `uvm_field_int(addr_in    , UVM_ALL_ON)
    `uvm_field_int(PREADY     , UVM_ALL_ON)
    `uvm_field_int(PSLVERR    , UVM_ALL_ON)
    `uvm_field_int(PRDATA     , UVM_ALL_ON)

    //outputs
    `uvm_field_int(PADDR         , UVM_ALL_ON)
    `uvm_field_int(PSEL          , UVM_ALL_ON)
    `uvm_field_int(PENABLE       , UVM_ALL_ON)
    `uvm_field_int(PWRITE        , UVM_ALL_ON)
    `uvm_field_int(PWDATA        , UVM_ALL_ON)
    `uvm_field_int(PSTRB         , UVM_ALL_ON)
    `uvm_field_int(rdata_out     , UVM_ALL_ON)
    `uvm_field_int(transfer_done , UVM_ALL_ON)
    `uvm_field_int(error         , UVM_ALL_ON)

  `uvm_object_utils_end
  
  function new(string name="");
    super.new(name);
  endfunction
  
endclass

