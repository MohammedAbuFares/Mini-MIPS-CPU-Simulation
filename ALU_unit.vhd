library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

--This entity is required to do arithmetic operations


entity ALU_unit is
  
    Port ( 
    
    Op1 : in STD_LOGIC_VECTOR (31 downto 0);
    Op2 : in STD_LOGIC_VECTOR (31 downto 0);
    Ctrl : in STD_LOGIC_VECTOR (2 downto 0);
    output : out STD_LOGIC_VECTOR (31 downto 0)
    );
    
    
end ALU_unit;



architecture Behavioral of ALU_unit is



signal  temp : unsigned (31 downto 0);
signal integ : integer ; 


begin
  
  
  process(Op1,Op2,Ctrl,temp,integ) is begin
    
    
    
  -- ADDUI & LH & SB
  
  if (Ctrl="000") then
    
    output <= Op1 + Op2;
    
  --ORI  
    
  elsif (Ctrl="001") then   
  
    output <= Op1 OR Op2;
    
  --SLL  
    
    elsif (Ctrl="010") then   
      
      integ <= to_integer(unsigned(Op1(10 downto 6)));
      
      temp <= unsigned (Op2);
      
      output <= STD_LOGIC_VECTOR( temp sll integ ) ;
      
   --XNOR
         
   elsif  (Ctrl = "011") then 
   
    output <= Op1 XNOR Op2;
    
   --NAND
    
    elsif (Ctrl = "100" ) then 
      
    output <= Op1 NAND Op2 ;
   
   --SUBI 
    
  elsif (Ctrl = "101") then
  
  output <= Op1 - Op2;
      
    
  end if;
  
      
    
    end process;
    end Behavioral;