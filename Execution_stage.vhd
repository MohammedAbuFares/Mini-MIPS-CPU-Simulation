library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

--Entity for Execution stage


entity Execution is
  
port

(
  

 -----------------------------------------Input SIGNALS
    
    Clock : in std_logic;
  
    
    --Control signals from ID stage
    
    Reg_wr_E, Mem2reg_E, Mem_wr_E,  ALU_srcE, Reg_dis_E: in std_logic := '0';
    ALU_ctrl_E                                         : in std_logic_vector (2 downto 0) := (others=>'0') ;
    
    --Control signals from Hazard unit to control muxes 
    
    Mux1_AE, Mux2_BE                                   : in std_logic_vector (1 downto 0);
    
    
    --Operands coming from ID
    
    OP1_E, OP2_E, Sign_imE, ALU_result_mem, WB_output  : in std_logic_vector(31 downto 0) := (others=>'0');
    R_s_from_D, R_t_from_D, R_d_from_D                 : in std_logic_vector(4 downto 0) := (others=>'0');
    
    
    -----------------------------------------Output SIGNALS
    
    
    --Control signals going to memory stage ... with the write_data_m for dist
    
    Reg_wr_M, Mem2reg_M, Mem_wr_M : out std_logic := '0';
    Write_Reg_M                   : out std_logic_vector(4 downto 0) := (others=>'0') ;
    ALU_out_M,  Write_Data_M      : out std_logic_vector(31 downto 0) := (others=>'0');
    
    --Signals going to hazard unit
    
    R_s_E, R_t_E                  : out std_logic_vector(4 downto 0) := (others=>'0');
    Reg_wr_E_HU, Mem2reg_E_HU     : out std_logic ;  
    Write_Reg_E_HU                : out std_logic_vector(4 downto 0) := (others=>'0') 
    
    
    
);

end Execution;


architecture behavior of Execution is 

--Components

------------------------

component ALU_unit is
  
    Port ( 
    
    Op1 : in STD_LOGIC_VECTOR (31 downto 0);
    Op2 : in STD_LOGIC_VECTOR (31 downto 0);
    Ctrl : in STD_LOGIC_VECTOR (2 downto 0);
    output : out STD_LOGIC_VECTOR (31 downto 0));
    
    
end component;

------------------------


component mux3_1 is
  
    Port ( SEL : in  STD_LOGIC_VECTOR (1 downto 0);
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           B   : in  STD_LOGIC_VECTOR (31 downto 0);
           C   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));
           
end component;

------------------------

component Dst_mux2_1 is
  
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (4 downto 0);
           B   : in  STD_LOGIC_VECTOR (4 downto 0);
           X   : out STD_LOGIC_VECTOR (4 downto 0));
           
end component;

------------------------

component mux2_1 is
  
    port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           B   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));
end component;

------------------------


component EX_MEM is
  
port

(

  
  Clock     : in std_logic;
  
  
  Reg_wr_E, Mem2reg_E, Mem_wr_E    : in std_logic := '0';
  Write_Reg_E                      : in std_logic_vector(4 downto 0) := (others=>'0') ;
  ALU_out_E,  Write_Data_E         : in std_logic_vector(31 downto 0) := (others=>'0');
  
  Reg_wr_M, Mem2reg_M, Mem_wr_M    : out std_logic := '0';
  Write_Reg_M                      : out std_logic_vector(4 downto 0) := (others=>'0') ;
  ALU_out_M, Write_Data_M          : out std_logic_vector(31 downto 0) := (others=>'0')
      
 );
 
end component;

------------------------

component shamt is 

port


(

ALU_ctrl : in std_logic_vector (2 downto 0);
mux_sel  : out std_logic := '0'

);

end component;

------------------------

signal mux1_out, mux2_out, mux3_out, mux5_out, ALU_result    : std_logic_vector(31 downto 0);
signal mux4_out                                              :std_logic_vector(4 downto 0);
signal mux5_sel                                              : std_logic;

begin 
  
  
  
  mux1: mux3_1 port map (Mux1_AE, OP1_E, WB_output, ALU_result_mem, mux1_out);
  mux2: mux3_1 port map (Mux2_BE, OP2_E, WB_output, ALU_result_mem, mux2_out);
  mux3: mux2_1 port map (ALU_srcE,mux2_out, Sign_imE,mux3_out);
  mux4: Dst_mux2_1 port map (Reg_dis_E, R_t_from_D, R_d_from_D,mux4_out);
  shmt: shamt port map (ALU_ctrl_E,mux5_sel);     
  mux5: mux2_1 port map ( mux5_sel, mux1_out, Sign_imE, mux5_out);   
  ALU:  ALU_unit port map (mux5_out, mux3_out, ALU_ctrl_E, ALU_result);
  Buff: EX_MEM  port map (Clock, Reg_wr_E, Mem2reg_E, Mem_wr_E,mux4_out, ALU_result, mux2_out,    --Input signals of buffer
                         Reg_wr_M, Mem2reg_M, Mem_wr_M,Write_Reg_M, ALU_out_M,  Write_Data_M);    --Output signals of buffer
    
  R_s_E          <= R_s_from_D; 
  R_t_E          <= R_t_from_D;                 
  Reg_wr_E_HU    <= Reg_wr_E;
  Mem2reg_E_HU   <= Mem2reg_E;   
  Write_Reg_E_HU <=  mux4_out;
  
end  behavior;

   
  
  
