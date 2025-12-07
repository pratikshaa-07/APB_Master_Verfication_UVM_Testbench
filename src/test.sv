//test-1
class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  environment   env;
  base_sequence seq1;

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = environment::type_id::create("env", this);
    seq1 = base_sequence::type_id::create("seq1");
  endfunction 

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq1.start(env.a_agent.seqr_h);
    phase.drop_objection(this);
  endtask

endclass

//test-2

class pready_1_seq_test extends uvm_test;

  `uvm_component_utils(pready_1_seq_test)

  environment   env;
  pready_1_seq  seq2;

  function new(string name = "pready_1_seq_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = environment::type_id::create("env", this);
    seq2 = pready_1_seq::type_id::create("seq2");
  endfunction 

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq2.start(env.a_agent.seqr_h);
    phase.drop_objection(this);
  endtask

endclass

//test-3

class pready_rand_seq_test extends uvm_test;

  `uvm_component_utils(pready_rand_seq_test)

  environment     env;
  pready_rand_seq seq3;

  function new(string name = "pready_rand_seq_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = environment::type_id::create("env", this);
    seq3 = pready_rand_seq::type_id::create("seq3");
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq3.start(env.a_agent.seqr_h);
    phase.drop_objection(this);
  endtask

endclass

//test-4

class transfer_rand_seq_test extends uvm_test;

  `uvm_component_utils(transfer_rand_seq_test)

  environment       env;
  transfer_rand_seq seq4;

  function new(string name = "transfer_rand_seq_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = environment::type_id::create("env", this);
    seq4 = transfer_rand_seq::type_id::create("seq4");
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq4.start(env.a_agent.seqr_h);
    phase.drop_objection(this);
  endtask

endclass

//test-5

class rand_seq_test extends uvm_test;

  `uvm_component_utils(rand_seq_test)

  environment env;
  rand_seq    seq5;

  function new(string name = "rand_seq_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = environment::type_id::create("env", this);
    seq5 = rand_seq::type_id::create("seq5");
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq5.start(env.a_agent.seqr_h);
    phase.drop_objection(this);
  endtask

endclass

//test-6

class mid_reset_1_test extends uvm_test;

  `uvm_component_utils(mid_reset_1_test)

  environment env;
  mid_reset_1 seq6;

  function new(string name = "mid_reset_1_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = environment::type_id::create("env", this);
    seq6 = mid_reset_1::type_id::create("seq6");
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq6.start(env.a_agent.seqr_h);
    phase.drop_objection(this);
  endtask

endclass

//test-7

class mid_reset_2_test extends uvm_test;

  `uvm_component_utils(mid_reset_2_test)

  environment env;
  mid_reset_2 seq7;

  function new(string name = "mid_reset_2_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = environment::type_id::create("env", this);
    seq7 = mid_reset_2::type_id::create("seq7");
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq7.start(env.a_agent.seqr_h);
    phase.drop_objection(this);
  endtask

endclass

//regression

class regression_test extends uvm_test;

  `uvm_component_utils(regression_test)

  environment env;
  regression_seq seq8;

  function new(string name = "mid_reset_2_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env  = environment::type_id::create("env", this);
    seq8 = regression_seq::type_id::create("seq8");
  endfunction 

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    seq8.start(env.a_agent.seqr_h);
    phase.drop_objection(this);
  endtask

endclass

