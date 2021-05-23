library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

--This entity is for buffer between ID stage and EX stage to hold data and release it on falling edge 

entity ID_EX is
  
port

(

  
  Clock     : in std_logic;
  Clr       : in std_logic := '0';
  
  Reg_wr, Mem2reg, Mem_wr, ALU_src, Reg_dis : in std_logic := '0';
  ALU_ctrl                                  : in std_logic_vector (2 downto 0)  := (others=>'0');
  R_s, R_t, R_d                             : in std_logic_vector (4 downto 0)  := (others=>'0');
  OP1, OP2, Sign_im                         : in std_logic_vector (31 downto 0) := (others=>'0');
  
  Reg_wrE, Mem2regE, Mem_wrE, ALU_srcE, Reg_disE : out std_logic := '0';
 	ALU_ctrlE                                      : out std_logic_vector (2 downto 0) := (others=>'0');
  R_sE, R_tE, R_dE                               : out std_logic_vector(4 downto 0) := (others=>'0'); 
  OP1_E, OP2_E, Sign_imE                         : out std_logic_vector(31 downto 0) := (others=>'0') 
     	
  
 );
 
end ID_EX;

architecture behavior of ID_EX is 

begin

process (Clock) 
  
  begin 
    
    if (falling_edge(Clock)) then 
      if (Clr ='0') then 
        
         Reg_wrE   <= Reg_wr;
         Mem2regE  <= Mem2reg;
         Mem_wrE   <= Mem_wr;
         ALU_srcE  <= ALU_src;
         Reg_disE  <= Reg_dis;
         ALU_ctrlE <= ALU_ctrl;
       
         R_sE <= R_s;
         R_tE <= R_t;
         R_dE <= R_d;
         OP1_E <= OP1;
         OP2_E <= OP2;
         Sign_imE <= Sign_im;
         
         
         
         elsif (Clr = '1') then 
         
         
         Reg_wrE   <= '0';
         Mem2regE  <= '0';
         Mem_wrE   <= '0';
         ALU_srcE  <= '0';
         Reg_disE  <= '0';
         ALU_ctrlE <= (others=>'0');
                
         R_sE <= (others=>'0');
         R_tE <= (others=>'0');
         R_dE <= (others=>'0');
         OP1_E <= (others=>'0');
         OP2_E <= (others=>'0');
         Sign_imE <= (others=>'0');
         
         
       end if;
       end if;
       
     end process;
     
   end behavior;
         
         
         

