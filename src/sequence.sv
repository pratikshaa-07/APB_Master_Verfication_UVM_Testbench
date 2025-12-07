// class base_sequence extends uvm_sequence#(seq_item);
//    seq_item req; 
//   `uvm_object_utils(base_sequence)
  
//   function new(string name="");
//     super.new(name);
//   endfunction
  
//   task body(); 
//     repeat(2)
//       begin
//          req=seq_item::type_id::create("req");
//          wait_for_grant();
//          req.randomize();
//          send_request(req);
//          wait_for_item_done();
//         `uvm_do_with(req,{PREADY==1'b1};);
//       end
//   endtask
// endclass

//pready=1 transfer=1
class base_sequence extends uvm_sequence#(seq_item);

  seq_item req; 

  `uvm_object_utils(base_sequence)
  
  function new(string name="base_sequence");
    super.new(name);
  endfunction
  
  task body(); 

    repeat(1) begin
      `uvm_do_with(req, { PRESET_n == 1'b0; })
    end

    repeat(500) 
    begin
      `uvm_do_with(req, { transfer == 1'b1; PRESET_n == 1'b1; })
    end

  endtask

endclass

//pready =1 transfer is randomized
class pready_1_seq extends uvm_sequence#(seq_item);
  seq_item req;
  
  `uvm_object_utils(pready_1_seq)
   
  function new(string name="base_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(1) 
      begin
        `uvm_do_with(req, { PRESET_n == 1'b0; })
      end
    repeat(500)
      begin
        `uvm_do_with(req, { PREADY == 1'b1; PRESET_n == 1'b1; })
      end
  endtask
endclass

//pready  is randomized transfer=1
class pready_rand_seq extends uvm_sequence#(seq_item);
  seq_item req;
  
  `uvm_object_utils(pready_rand_seq)
   
  function new(string name="base_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(1) 
      begin
        `uvm_do_with(req, { PRESET_n == 1'b0; })
      end
    repeat(500)
      begin
        `uvm_do_with(req, { transfer == 1'b1; PRESET_n == 1'b1; })
      end
  endtask
endclass

//transfer rand pready=1
class transfer_rand_seq extends uvm_sequence#(seq_item);
  seq_item req;
  
  `uvm_object_utils(transfer_rand_seq)
   
  function new(string name="base_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(1) 
      begin
        `uvm_do_with(req, { PRESET_n == 1'b0; })
      end
    repeat(500)
      begin
        `uvm_do_with(req, { PREADY == 1'b1; PRESET_n == 1'b1; })
      end
  endtask
endclass

//both random
class rand_seq extends uvm_sequence#(seq_item);
  seq_item req;
  
  `uvm_object_utils(rand_seq)
   
  function new(string name="base_sequence");
    super.new(name);
  endfunction
  
  task body();
    repeat(1) 
      begin
        `uvm_do_with(req, { PRESET_n == 1'b0; })
      end
    repeat(500)
      begin
        `uvm_do_with(req, { PRESET_n == 1'b1; })
      end
  endtask
endclass


//mid reset with pready=1 transfer randomized

class mid_reset_1 extends uvm_sequence#(seq_item);
  seq_item req;
  
  `uvm_object_utils(mid_reset_1)
   
  function new(string name="");
    super.new(name);
  endfunction
  
  task body();
    repeat(1) 
      begin
        `uvm_do_with(req, { PRESET_n == 1'b0; })
      end
    repeat(500)
      begin
        `uvm_do_with(req, { PREADY==1'b1; })
      end
  endtask
endclass

//mid reset with pready randomized transfer=1

class mid_reset_2 extends uvm_sequence#(seq_item);
  seq_item req;
  
  `uvm_object_utils(mid_reset_2)
   
  function new(string name="");
    super.new(name);
  endfunction
  
  task body();
    repeat(1) 
      begin
        `uvm_do_with(req, { PRESET_n == 1'b0; })
      end
    repeat(500)
      begin
        `uvm_do_with(req, { transfer == 1'b1;})
      end
  endtask
endclass

//regerssion 
class regression_seq extends uvm_sequence#(seq_item);

  `uvm_object_utils(regression_seq)

  base_sequence        seq0;
  pready_1_seq         seq1;
  pready_rand_seq      seq2;
  transfer_rand_seq    seq3;
  rand_seq             seq4;
  mid_reset_1          seq5;
  mid_reset_2          seq6;

  function new(string name="");
    super.new(name);
  endfunction

  task body();

    `uvm_info("REGRESSION", "Starting Base Sequence", UVM_LOW)
    `uvm_do(seq0)

    `uvm_info("REGRESSION", "Starting PREADY = 1 Sequence", UVM_LOW)
    `uvm_do(seq1)

    `uvm_info("REGRESSION", "Starting PREADY Random Sequence", UVM_LOW)
    `uvm_do(seq2)

    `uvm_info("REGRESSION", "Starting Transfer Random Sequence", UVM_LOW)
    `uvm_do(seq3)

    `uvm_info("REGRESSION", "Starting Fully Random Sequence", UVM_LOW)
    `uvm_do(seq4)

    `uvm_info("REGRESSION", "Starting Mid Reset 1 Sequence", UVM_LOW)
    `uvm_do(seq5)

    `uvm_info("REGRESSION", "Starting Mid Reset 2 Sequence", UVM_LOW)
    `uvm_do(seq6)

  endtask

endclass


