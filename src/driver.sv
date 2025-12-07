class driver extends uvm_driver#(seq_item);
  
  virtual intf.DRV vif;
  bit prev_transfer;
  static int i;
  bit count;
  `uvm_component_utils(driver)
  
  function new(string name="",uvm_component parent);
    super.new(name,parent);
    i=0;
    count=0;
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(!uvm_config_db#(virtual intf)::get(this,"","vif",vif))
      `uvm_fatal("DRIVER-VIF","virtual interface not set");
    
  endfunction
  
  task drive(seq_item req);    
     
    vif.drv_cb.transfer    <= req.transfer;
    vif.drv_cb.PRESET_n    <= req.PRESET_n;
    `uvm_info("DRIVER", $sformatf("[drv-%0d]sent transfer=%0d reset=%0d",i,req.transfer,req.PRESET_n), UVM_LOW)

    if(req.PRESET_n == 1 && count==1)       
      begin
        if(req.transfer == 1)
        begin
          
          //repeat(1) @(vif.drv_cb);
          
          
          vif.drv_cb.strb_in     <= req.strb_in;
          vif.drv_cb.wdata_in    <= req.wdata_in;
          vif.drv_cb.write_read  <= req.write_read;
          vif.drv_cb.addr_in     <= req.addr_in;
          `uvm_info("DRIVER", $sformatf("[drv-%0d] sent strb=%0d | wdata=%0d | read_write = %0d | address =%0d",i,req.strb_in,req.wdata_in,req.write_read,req.addr_in), UVM_LOW)
          
          //repeat(2) @(vif.drv_cb);
          //wait(vif.drv_cb.PSEL);
          repeat(1) @(vif.drv_cb);
          if(req.PREADY == 1)
            begin
              vif.drv_cb.PREADY  <= req.PREADY;
              vif.drv_cb.PSLVERR <= req.PSLVERR;
              vif.drv_cb.PRDATA  <= req.PRDATA;
              `uvm_info("DRIVER", $sformatf("[drv-%0d] PREADY is 1 No wait cycles --- sent  PREADY=%0d | PSLVERR = %0d | PRDATA =%0d",i,req.PREADY,req.PSLVERR,req.PRDATA), UVM_LOW)
            @(vif.drv_cb);
            end
          else
            begin
              vif.drv_cb.PREADY<=req.PREADY;
              while(req.PREADY!=1)     
                begin
                  $display("DRIVER INSIDE WAIT CYCLE");
                  @(vif.drv_cb);
                  req.randomize();
                end
              vif.drv_cb.PREADY  <= req.PREADY;
              vif.drv_cb.PSLVERR <= req.PSLVERR;
              vif.drv_cb.PRDATA  <= req.PRDATA;
              `uvm_info("DRIVER", $sformatf("[drv-%0d] Got PREADY as 1 --- sent  PREADY=%0d | PSLVERR = %0d | PADDR =%0d",i,req.PREADY,req.PSLVERR,req.PRDATA), UVM_LOW)
              //@(vif.drv_cb);
            end           
        end
      end
      //else if(req.PRESET_n==1 && count==0)

//         else if(req.transfer == 1 && prev_transfer == 1)
//           begin
//             prev_transfer = req.transfer;

//             vif.strb_in     <= req.strb_in;
//             vif.wdata_in    <= req.wdata_in;
//             vif.write_read  <= req.write_read;
//             vif.addr_in     <= req.addr_in;

//             repeat(1) @(posedge vif.drv_cb);
          
//             if(req.PREADY == 1)
//               begin
//                 vif.PREADY  <= req.PREADY;
//                 vif.PSLVERR <= req.PSLVERR;
//                 vif.PRDATA  <= req.PRDATA;
//               end
//             else
//               begin
//                 while(req.PREADY == 0)   // FIX — reference req
//                   begin
//                     @(vif.drv_cb);
//                     req.randomize();
//                     vif.PREADY <= req.PREADY;
//                   end
//                 vif.PSLVERR <= req.PSLVERR;
//                 vif.PRDATA  <= req.PRDATA;
//               end     
//            end
//         else
//           prev_transfer = req.transfer;
//       end
    
     @(vif.drv_cb);
    i++;
  endtask
  
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    repeat(3) @(vif.drv_cb);
    forever
      begin
        seq_item_port.get_next_item(req);     
        drive(req);
        seq_item_port.item_done();            
      end
  endtask
  
endclass

