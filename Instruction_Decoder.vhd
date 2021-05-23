library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--This entity is the Instruction Decoder stage 


entity Instr_decode is
  
  port (
    
    ----------------------------------------INPUT SIGNALS
    
    Clock            : in std_logic;
    Clr              : in std_logic := '0';
    
    -- From hazard
    
    Mux1_AD, Mux2_BD : in std_logic := '0';
    
    -- inputs coming from WB stage
    
    WB_Write_EN      : in std_logic := '0';
    WB_add_dis       : in std_logic_vector(4 downto 0);
    WB_Dat_2b_written: in std_logic_vector (31 downto 0);
    
    --inputs from IF and EX (First two are from IF and last one is from EX)
    
    Full_intruction, NPC_D, ALU_Result : in std_logic_vector (31 downto 0) := (others=>'0'); 
    
    -----------------------------------------OUTPUT SIGNALS
    
    
    --for controller output to the EX stage
    
    Reg_wrE, Mem2regE, Mem_wrE, ALU_srcE, Reg_disE : out std_logic := '0';
    ALU_ctrlE                                      : out std_logic_vector (2 downto 0) := (others=>'0') ;
    
    --control signals for IF and ID stage 
    
    PcSr_D                :  out std_logic := '0';
    Jump_D                :  out STD_LOGIC_VECTOR (1 downto 0):="00";
    
    --PCBranchD signal from ID to IF to update PC 
    
    PC_branch_D           : out std_logic_vector (31 downto 0);
    
    -- Operands and distination values from ID to EX 
    
    OP1_E, OP2_E, Sign_imE: out std_logic_vector(31 downto 0) := (others=>'0');
    R_sE, R_tE, R_dE      : out std_logic_vector(4 downto 0) := (others=>'0');
     
    
    --For Hazard unit 
    
    R_sD, R_tD            : out std_logic_vector(4 downto 0);
    Brch_D                : out std_logic := '0'
    
  ); 
  
end Instr_decode;


architecture behavior of Instr_decode is 


--Components

-------------------------

component mux2_1 is
  
    port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           B   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));
           
           
end component;
    
    
-------------------------


component shifter is
  
port (    
  
  X  : in  std_logic_vector(31 downto 0);
  Y  : out std_logic_vector(31 downto 0)
  
  );
  
end component;  

-------------------------


component sign_ext is 
  
  
    port ( 
    
    A : in std_logic_vector(15 downto 0);
    B : out std_logic_vector(31 downto 0));
    
end component;

-------------------------


component if_equal is 
  
  port ( 
  
  A : in STD_LOGIC_VECTOR (31 downto 0);
  B : in STD_LOGIC_VECTOR (31 downto 0);
  C : out STD_logic);
            
  end component; 
  
  
-------------------------


component adderD is 
  
  port ( 
  
  A : in  STD_LOGIC_VECTOR  (31 downto 0);
  B : in  STD_LOGIC_VECTOR  (31 downto 0);
  C : out STD_LOGIC_VECTOR  (31 downto 0)
  
  );
            
  end component;   
  
-------------------------

component ctrl_unit is
  
  
    Port ( 
    
        OpCd :      in STD_LOGIC_vector(5 downto 0);
        fnc  :      in STD_LOGIC_vector(5 downto 0);
        
        
        Reg_wr_D   :   out STD_LOGIC:='0';
        Mem2reg_D  :   out STD_LOGIC:='0';
        Mem_wr_D   :   out STD_LOGIC:='0';
        ALU_src_D  :   out STD_LOGIC:='0';
        Reg_dis_D  :   out STD_LOGIC:='0';    
        Brnch_D    :   out STD_LOGIC:='0';
        Jmp_D      :   out STD_LOGIC_VECTOR (1 downto 0):="00";
        
        ALU_ctrl_D :   out STD_LOGIC_VECTOR (2 downto 0):="000"
    
    );
    
end component;

-------------------------


component reg_box is
  
  
  port (
    
    
      Clock: in std_logic;
      En_WB: in std_logic := '0';  
      Operand1: in std_logic_vector(4 downto 0) := (others => '0');
      Operand2: in std_logic_vector(4 downto 0) := (others => '0');
      WB_DST: in std_logic_vector(4 downto 0) := (others => '0'); 
      WB_DATA: in std_logic_vector(31 downto 0) := (others => '0');
      Output_oper1: out std_logic_vector(31 downto 0) := (others => '0');
      Output_oper2: out std_logic_vector(31 downto 0) := (others => '0')
      
    );
    
  end component;
  
  
--------------------------


component ID_EX is
  
port

(

  
  Clock     : in std_logic;
  Clr       : in std_logic := '0';
  
  Reg_wr, Mem2reg, Mem_wr, ALU_src, Reg_dis : in std_logic := '0';
  ALU_ctrl : in std_logic_vector (2 downto 0) := (others=>'0') ;
  R_s, R_t, R_d : in std_logic_vector(4 downto 0) := (others=>'0') ;
  OP1, OP2, Sign_im: in std_logic_vector(31 downto 0) := (others=>'0');
  
  Reg_wrE, Mem2regE, Mem_wrE, ALU_srcE, Reg_disE : out std_logic := '0';
   ALU_ctrlE : out std_logic_vector (2 downto 0) := (others=>'0');
  R_sE, R_tE, R_dE : out std_logic_vector(4 downto 0) := (others=>'0'); 
  OP1_E, OP2_E, Sign_imE: out std_logic_vector(31 downto 0) := (others=>'0') 
       
  
 );
 
end component;


---------------------------

component and_gate is

    port(A : in std_logic;      
         B : in std_logic;      
         C : out std_logic);    

end component;

---------------------------

component mux3_1 is
  
    Port ( SEL : in  STD_LOGIC_VECTOR (1 downto 0);
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           B   : in  STD_LOGIC_VECTOR (31 downto 0);
           C   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));
           
end component;


---------------------------

component jmp_uncon is 

port


(

OpCd     : in std_logic_vector (5 downto 0);
mux_sel  : out std_logic := '0'

);

end component;

----------------------------


component J_calc is 
  
  port (
  
  Instruction : in STD_LOGIC_VECTOR (25 downto 0);
  PC_4D       : in STD_LOGIC_VECTOR (31 downto 0); 
  
  J_address   : out STD_LOGIC_VECTOR (31 downto 0)
  
);


end component;


-----------------------------


component PCSrc_mux is
  
  
  
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC;
           B   : in  STD_LOGIC;
           X   : out STD_LOGIC
           
           );
           
end component;

-------------------------------




signal Output_Reg_box1, Output_Reg_box2, mux1_output, mux2_output, signExt_out, shifter_out1, shifter_out2, adder_output, J_add   : std_logic_vector(31 downto 0);
signal output_ifequal, output_J_Src, output_andg : std_logic;

--signals for control unit output
signal Reg_W , Mem_to_REG, Mem_W, Arith_src, Reg_DST, brnch : std_logic; 
signal jmp        :         STD_LOGIC_VECTOR (1 downto 0);
signal Arith_code :  std_logic_vector(2 downto 0);


begin 
  
  
Reg :reg_box port map (Clock, WB_Write_EN, Full_intruction(25 downto 21),Full_intruction(20 downto 16),WB_add_dis ,WB_Dat_2b_written, Output_Reg_box1,Output_Reg_box2);
mux1: mux2_1 port map (Mux1_AD, Output_Reg_box1, ALU_Result, mux1_output);
mux2: mux2_1 port map (Mux2_BD, Output_Reg_box2, ALU_Result, mux2_output);
if_equ: if_equal port map (mux1_output, mux2_output, output_ifequal); 
ctrl: ctrl_unit  port map (Full_intruction(31 downto 26), Full_intruction(5 downto 0), Reg_W , Mem_to_REG, Mem_W, Arith_src, Reg_DST, brnch, jmp, Arith_code);  
andg: and_gate   port map (output_ifequal, brnch, output_andg);
  
J_U : jmp_uncon  port map (  Full_intruction(31 downto 26), output_J_Src);
mux0 : PCSrc_mux port map ( output_J_Src, output_andg , output_J_Src, PcSr_D);
  
  
J_Ad:  J_calc   port map ( Full_intruction(25 downto 0), NPC_D, J_add);
  
sign: sign_ext  port map (Full_intruction(15 downto 0), signExt_out);
shift1: shifter port map (signExt_out, shifter_out1);
shift2: shifter port map (mux2_output, shifter_out2);
adder: adderD   port map   (shifter_out1, NPC_D, adder_output);
mux3:  mux3_1   port map (jmp, Output_Reg_box1,  adder_output, J_add ,PC_branch_D);
  
buf:   ID_EX    port map (Clock, Clr, Reg_W, Mem_to_REG, Mem_W, Arith_src, Reg_DST, Arith_code, Full_intruction(25 downto 21), Full_intruction(20 downto 16),
Full_intruction(15 downto 11), Output_Reg_box1, Output_Reg_box2, signExt_out, Reg_wrE, Mem2regE, Mem_wrE, ALU_srcE, Reg_disE, ALU_ctrlE, R_sE, R_tE, R_dE, 
OP1_E, OP2_E, Sign_imE);


R_sD    <= Full_intruction(25 downto 21);
R_tD    <= Full_intruction(20 downto 16);
Brch_D  <= brnch;


end behavior;


  
  
 
  
  
  

  
    
    
    
     
    
    
    
  
  
 
  
  
  

  
    
    
    
     
    
    
    
  
  

  
    
    
    
     
    
    
    