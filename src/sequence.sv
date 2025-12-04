// class base_sequence extends uvm_sequence#(seq_item);
//    seq_item req; 
//   `uvm_object_utils(base_sequence)
  
//   function new(string name="");
//     super.new(name);
//   endfunction
  
//   task body(); 
//     repeat(2)
//       begin
// //         req=seq_item::type_id::create("req");
// //         wait_for_grant();
// //         req.randomize();
// //         send_request(req);
// //         wait_for_item_done();
//         `uvm_do_with(req,{PREADY==1'b1};);
//       end
//   endtask
// endclass

class base_sequence extends uvm_sequence#(seq_item);

  seq_item req; 

  `uvm_object_utils(base_sequence)
  
  function new(string name="base_sequence");
    super.new(name);
  endfunction
  
  task body(); 
    repeat(4) begin
      `uvm_do_with(req, { req.PREADY == 1'b1; req.transfer==1'b1;})
    end
  endtask

endclass

