library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

--This entity is for Instruction Fetch stage

entity Instr_fetch is
  
  port (
    
      Clock   : in std_logic;
      En_PC   : in std_logic := '1';    --Stall F
      En_BUFF : in std_logic := '1';    --Stall D 
      Clr     : in std_logic := '0';
      MUX_sel : in std_logic:= '0';
      NPC_IMM : in std_logic_vector(31 downto 0) :=  (others =>'0');   --PCbranchD
      
      Final_Instr_IF, Final_PC_IF: out std_logic_vector(31 downto 0) :=  (others =>'0')
      
        );
        
end Instr_fetch;


architecture behavior of Instr_fetch is 


component mux2_1
  

    port (     SEL : in  STD_LOGIC;
               A   : in  STD_LOGIC_VECTOR (31 downto 0);
               B   : in  STD_LOGIC_VECTOR (31 downto 0);
               X   : out STD_LOGIC_VECTOR (31 downto 0)
               
          );
          
        end component;
        
  -------------------------------
        
        
component adder 

port ( 
  
  A : in  STD_LOGIC_VECTOR  (31 downto 0);
  B : out STD_LOGIC_VECTOR  (31 downto 0)
  
  );
            
  end component;   
  
  -------------------------------
  
  component Program_c
    
    
    port (
      
        Clock  : in std_logic;
        En     : in std_logic := '1';
        PC_in  : in std_logic_vector(31 downto 0)  :=  (others => '0');
        PC_out : out std_logic_vector(31 downto 0) :=  (others => '0')
    );
    
  end component;
  
  -------------------------------
  
  component Ins_m
    
  port
  
  (
  
  PC:        in std_logic_vector(31 downto 0);        
  Data_out:  out std_logic_vector(31 downto 0) 
  
  ); 
  
  end component;
  
  --------------------------------
  
  component IF_ID
  
  port
  
  (
  
    
    En        : in std_logic := '1';
    Clock     : in std_logic;
    Clr       : in std_logic := '0';
    Input_PC  : in std_logic_vector(31 downto 0) :=  (others =>'0'); 	 
    Instr_in  : in std_logic_vector(31 downto 0) :=  (others =>'0');   
    Instr_out : out std_logic_vector (31 downto 0) := (others => '0');  	
    Output_PC : out std_logic_vector (31 downto 0) := (others => '0')	
    
   );
   
 end component;
 
 -------------------------------
  
  
  signal mux_out, pc_out, instructionMem_out, adder_out : std_logic_vector(31 downto 0);
  
  begin 
    
    mux:     mux2_1    port map (MUX_sel, adder_out, NPC_IMM,  mux_out);
    pc :     Program_c port map (Clock, En_PC, mux_out, pc_out);
    Add:     adder     port map (pc_out, adder_out);
    instM:   Ins_m     port map (pc_out, instructionMem_out);
    Buf:    IF_ID      port map (En_BUFF, Clock, Clr, adder_out, instructionMem_out, Final_Instr_IF, Final_PC_IF );
         
      
  end behavior;
    
      
       
        
        
        
        
