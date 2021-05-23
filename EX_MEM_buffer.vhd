library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

--Entity for buffer between EX stage and MEM stage to hold value and release it on falling edge 

entity EX_MEM is
  
port

(

  
  Clock     : in std_logic;
  
  
  Reg_wr_E, Mem2reg_E, Mem_wr_E     : in std_logic := '0';
  Write_Reg_E                       : in std_logic_vector(4 downto 0) := (others=>'0') ;
  ALU_out_E,  Write_Data_E          : in std_logic_vector(31 downto 0) := (others=>'0');
  
  Reg_wr_M, Mem2reg_M, Mem_wr_M     : out std_logic := '0';
  Write_Reg_M                       : out std_logic_vector(4 downto 0) := (others=>'0') ;
  ALU_out_M, Write_Data_M           : out std_logic_vector(31 downto 0) := (others=>'0')
  
  
      
 );
 
end EX_MEM;


architecture behavior of EX_MEM is
  
 begin
   
  process(Clock)
    
  begin
    
    if (falling_edge(Clock)) then

     Reg_wr_M  <= Reg_wr_E;
     Mem2reg_M <= Mem2reg_E;
     Mem_wr_M  <= Mem_wr_E;

     ALU_out_M    <= ALU_out_E;
     Write_Data_M <= Write_Data_E;
     Write_Reg_M  <= Write_Reg_E;

    end if;
    
  end process;
  
end behavior;
