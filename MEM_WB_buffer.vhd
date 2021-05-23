library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

--This entity is for buffer between MEM and EX stage to hold data and release on falling edge

entity MEM_EX is
  
port

(

  
  Clock     : in std_logic;
  
  
  Reg_wr_M, Mem2reg_M        : in std_logic := '0';
  Write_Reg_M                : in std_logic_vector(4 downto 0) := (others=>'0') ;
  Data_mem_out, ALU_out_M    : in std_logic_vector(31 downto 0) := (others=>'0');
  
  
  Reg_wr_W, Mem2reg_W        : out std_logic := '0';
  Write_Reg_W                : out std_logic_vector(4 downto 0) := (others=>'0') ;
  Data_mem_out_W, ALU_out_W  : out std_logic_vector(31 downto 0) := (others=>'0')
  
      
 );
 
end MEM_EX;


architecture behavior of MEM_EX is
  
 begin
   
  process(Clock)
    
  begin
    
    if (falling_edge(Clock)) then

     Reg_wr_W        <= Reg_wr_M;
     Mem2reg_W       <= Mem2reg_M;
     Data_mem_out_W  <= Data_mem_out;
     ALU_out_W       <= ALU_out_M;
     Write_Reg_W     <= Write_Reg_M;
     
   
    end if;
    
  end process;
  
end behavior;
