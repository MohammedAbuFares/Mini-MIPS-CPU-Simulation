library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.numeric_std.all;

--This entity is for buffer between IF and ID stage to hold data and release it on falling edge.. it will also stall the buffer if required by control EN signal

entity IF_ID is
  
port

(

  
  En        : in std_logic := '1';
  Clock     : in std_logic;
  Clr       : in std_logic := '0';
  Input_PC  : in std_logic_vector(31 downto 0) :=  (others =>'0'); 	    --PC input to this buff
  Instr_in  : in std_logic_vector(31 downto 0) :=  (others =>'0');   --Instruction memory output to this buff
  Instr_out : out std_logic_vector (31 downto 0) := (others => '0');  	--Output from this buff
  Output_PC : out std_logic_vector (31 downto 0) := (others => '0')	--Output from this buff, input from the pc
  
 );
 
end IF_ID;

-- Begin Architecture

architecture behavioral of IF_ID is


 begin
   
 
  process(Clock)
    
    begin
      
      if (falling_edge(Clock)) then
        
      if ((En ='1') and (Clr = '0')) then
        
        Instr_out <= Instr_in;
        
        Output_PC <= Input_PC;

      elsif (Clr = '1') then
        
        Instr_out   <= (others => '0') ;
        
        Output_PC   <= (others => '0')  ;
  
      end if;
      end if;
      
  end process;
  
end behavioral;
