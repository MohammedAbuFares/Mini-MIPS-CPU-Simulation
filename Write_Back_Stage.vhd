library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

--This entity is the WB stage 

entity WB is


port (
  
  Reg_wr_W, Mem2reg_W        : in std_logic := '0';
  
  Write_Reg_W                : in std_logic_vector(4 downto 0) := (others=>'0') ;
  Data_mem_out_W, ALU_out_W  : in std_logic_vector(31 downto 0) := (others=>'0');
  
  
  Final_result     : out std_logic_vector (31 downto 0) := (others=>'0'); --going to previous stages 
  WB_add_dis       : out std_logic_vector (4 downto 0);
  
  Reg_wr_W_out     : out std_logic := '0';  --Control signal going to Decoding stage
  
  
  Reg_wr_W_HU      : out std_logic := '0'; --Going to hazard unit
  WB_add_dis_HU    : out std_logic_vector(4 downto 0)
  
);

end WB ;


architecture structure of WB is 

component mux2_1 is
  
    port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           B   : in  STD_LOGIC_VECTOR (31 downto 0);
           X   : out STD_LOGIC_VECTOR (31 downto 0));
           
end component;


begin 
  
  
  mux1: mux2_1 port map (Mem2reg_W, ALU_out_W, Data_mem_out_W,Final_result);
    
  Reg_wr_W_HU   <= Reg_wr_W;
  Reg_wr_W_out  <=  Reg_wr_W;
  WB_add_dis    <= Write_Reg_W;
  WB_add_dis_HU <= Write_Reg_W;
  
  
  
  
end structure;


    



