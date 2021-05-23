library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

--Data Memory stage 

entity Data_mem is


port
(

-----------------------------------------Input SIGNALS

  Clock : in std_logic;
  
  --Control signals from execution stage
  
  Reg_wr_E, Mem2reg_E, Mem_wr_E   : in std_logic := '0';
  
  --Outputs from execution stage 
  
  Write_Reg_E                     : in std_logic_vector(4 downto 0) := (others=>'0') ;
  ALU_out_E, Write_Data_E         : in std_logic_vector(31 downto 0) := (others=>'0');


-----------------------------------------Output SIGNALS

  --Control signals going to WB 
  
  Reg_wr_W, Mem2reg_W        : out std_logic := '0';
  
  --Outputs going to WB
  
  Write_Reg_W                : out std_logic_vector(4 downto 0) := (others=>'0') ;
  Data_mem_out_W, ALU_out_W  : out std_logic_vector(31 downto 0) := (others=>'0');
  
  --Signals going to HU 
  
  Write_Reg_M_HU               : out std_logic_vector(4 downto 0) := (others=>'0');
  Reg_wr_M_HU                  : out std_logic ; 
  
  
  --Forward ALU output 
  
  ALU_out_Fwd              : out std_logic_vector(31 downto 0) := (others=>'0');
  
  Mem2reg_M                :  out std_logic:= '0' 
  
  
  
);
end Data_mem;



architecture structure of Data_mem is 


--Components 

----------------------------

component Memory is
  
port

(
  Clock         : in std_logic := '0';
  Mem_wr_M      : in std_logic := '0'; 
  ALU_Result_M  : in std_logic_vector(31 downto 0) := (others => '0'); 	
  Mem_Data_write: in std_logic_vector(31 downto 0) := (others => '0');	
  
  Mem_out       : out std_logic_vector(31 downto 0) := (others => '0')	
);

end component;

----------------------------

component MEM_EX is
  
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
 
end component;

----------------------------

component twos_comp is 
   
   port 
   
   (
   
   ALU_resultM : in std_logic_vector (31 downto 0) := (others => '0'); 
   output      : out std_logic_vector (31 downto 0) := (others => '0')
   
   );
   
   
 end component;
 
----------------------------
 
 

signal DATA_MEM_OUTPUT, tw_comp_out    : std_logic_vector(31 downto 0);

begin 
  
  
  tws_cmp : twos_comp port map ( ALU_out_E, tw_comp_out);
  DataMem : Memory port map (Clock,Mem_wr_E, tw_comp_out,Write_Data_E , DATA_MEM_OUTPUT);
  Buff    : MEM_EX   port map (Clock, Reg_wr_E, Mem2reg_E, Write_Reg_E, DATA_MEM_OUTPUT, ALU_out_E,  --Input signals of buffer   
                               Reg_wr_W, Mem2reg_W,Write_Reg_W, Data_mem_out_W, ALU_out_W);          --Output signals of buffer 
    
  Write_Reg_M_HU <=  Write_Reg_E;
  Reg_wr_M_HU    <=  Reg_wr_E; 
  ALU_out_Fwd    <=  ALU_out_E;
  Mem2reg_M      <=  Mem2reg_E;
  
  
end structure;


