interface assertions_apb(
  PCLK, PRESET_n, transfer, PSLVERR, write_read, addr_in, wdata_in,
  PRDATA, PREADY, strb_in,
  PSEL, PSTRB, PWDATA, PADDR, PWRITE, PENABLE,
  error, transfer_done, rdata_out
);

  // input signals (from TB to DUT)
  input PCLK;
  input PRESET_n;
  input transfer;
  input PSLVERR;
  input write_read;
  input [7:0]  addr_in;
  input [31:0] wdata_in;
  input [31:0] PRDATA;
  input        PREADY;
  input [3:0]  strb_in;

  // output signals (from DUT to TB)
  input        PSEL;
  input [3:0]  PSTRB;
  input [31:0] PWDATA;
  input [7:0]  PADDR;
  input        PWRITE;
  input        PENABLE;
  input        error;
  input        transfer_done;
  input [31:0] rdata_out;

  //-----------------------//
  //-----RESET CHECK-------//
  //-----------------------//
  
  property p1;
    @(posedge PCLK)
    !PRESET_n |-> (PSEL=='b0 && PWDATA=='b0 && PSTRB=='b0 && 
                   PADDR=='b0 && PWRITE=='b0 && PENABLE=='b0 && 
                   error=='b0 && transfer_done=='b0 && rdata_out=='b0); 
  endproperty
  
  RESET_CHECK: assert property (p1)
    $info("RESET_CHECK-assertion passed %0t",$time);
  else
    $error("RESET_CHECK-assertion failed %0t",$time);
    
  //---------------------------//
  //----transfer_done_check----//
  //---------------------------//
    
  property p2;
    @(posedge PCLK) disable iff(!PRESET_n || !transfer)
    (PSEL && PREADY && PENABLE) |-> transfer_done;
  endproperty
    
  transfer_done_check: assert property (p2)
    $info("TRANSFER_DONE_CHECK-assertion passed %0t",$time);
  else
    $error("TRANSFER_DONE_CHECK-assertion failed %0t",$time);
      
    
  //-----------------------------//
  //-----PENABLE CHECK-----------//
  //-----------------------------//      
      
  property p3;
    @(posedge PCLK) disable iff(!PRESET_n || !transfer)
    $rose(PSEL) |=> PENABLE;
  endproperty
  
  PENABLE_CHECK: assert property (p3)
    $info("PENABLE_CHECK-assertion passed %0t",$time);
  else
    $error("PENABLE_CHECK-assertion failed %0t",$time);
        
  //-------------------------------------------//
  //-----stability of psel and penable----------//
  //------------------------------------------//    
    
  property p4;
    @(posedge PCLK) disable iff(!PRESET_n || !transfer)
    (PSEL && PENABLE) |-> (PSEL && PENABLE) until_with PREADY;
  endproperty
        
  psel_penable_stability: assert property (p4)
    $info("psel_penable_stability-assertion passed %0t",$time);
  else
    $error("psel_penable_stability-assertion failed %0t",$time);
          
  //-------------------------------------------//
  //--------phase transition check-------------//
  //------------------------------------------//    
    
  property p5;
    @(posedge PCLK) disable iff(!PRESET_n || !transfer)
    $rose(PSEL) |=> PENABLE ##[0:$] PREADY##1 !PENABLE;
  endproperty
        
  phase_transition_check: assert property (p5)
    $info("phase_transition_check-assertion passed %0t",$time);
  else
    $error("phase_transition_check-assertion failed %0t",$time);
            
  //-----------------------------------------------------------//
  //-------pwrite =1 and prdata=0 and pwdata is known value----//
  //-----------------------------------------------------------//    
    
  property p6;
    @(posedge PCLK) disable iff(!PRESET_n || !transfer)
    (PWRITE && PREADY) |-> ($stable(rdata_out) && !($isunknown(PWDATA)));
  endproperty
        
  pwrite_rdata_check: assert property (p6)
    $info("pwrite_rdata_out_check-assertion passed %0t",$time);
  else
    $error("pwrite_rdata_out_check-assertion failed %0t",$time);           
           

  //-----------------------------------------------------------//
  //-------pwrite =0 and pwdata=0 and prdata is known value
  //-----------------------------------------------------------//    
    
  property p7;
    @(posedge PCLK) disable iff(!PRESET_n || !transfer)
    (!PWRITE && PREADY) |-> (PWDATA=='b0 && !($isunknown(rdata_out)));
  endproperty
        
  pwrite_pwdata_check: assert property (p7)
    $info("pwrite_pwdata_check-assertion passed %0t",$time);
  else
    $error("pwrite_pwdata_check-assertion failed %0t",$time);  

endinterface

