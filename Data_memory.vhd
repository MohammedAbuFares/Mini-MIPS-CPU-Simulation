library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_SIGNED.ALL;
use STD.TEXTIO.all;

--Entity for memory to store and load data when required 


entity Memory is
  
port

(
  Clock         : in std_logic;
  Mem_wr_M      : in std_logic := '0'; 
  ALU_Result_M  : in std_logic_vector(31 downto 0) := (others => '0'); 	
  Mem_Data_write: in std_logic_vector(31 downto 0) := (others => '0');	
  
  Mem_out: out std_logic_vector(31 downto 0) := (others => '0')	
);

end Memory;



architecture behavior of Memory is 

  type Memory_blcks is array (0 to 2000) of std_logic_vector(7 downto 0); 
  
 
 
    signal d_m: Memory_blcks:= (others=>(others=>'0')); 
    

begin
  
  
 
 Mem_out <= "0000000000000000" & d_m(to_integer(unsigned(ALU_Result_M))+2) & d_m(to_integer(unsigned(ALU_Result_M))+3);  --Extracting value 
   
   
  process(Clock) is
    
 
  
  begin
    
  
  
  d_m(8)  <= "00000000" ; d_m(9) <= "00110100" ; d_m(10) <= "00000000"; d_m(11) <= "00001100";   --Memory MEM[8] value 
 
 
 
 if falling_edge(Clock) then  
   
           if (Mem_wr_M='1') then 
           
      --Storing byte
      
             d_m (to_integer(unsigned(ALU_Result_M)))   <= "00000000";
             d_m (to_integer(unsigned(ALU_Result_M))+1) <= "00000000";
             d_m (to_integer(unsigned(ALU_Result_M))+2) <= "00000000";
             d_m (to_integer(unsigned(ALU_Result_M))+3) <= Mem_Data_write(7 downto 0);
             
           end if;
           
         end if;

   end process;

end behavior;
