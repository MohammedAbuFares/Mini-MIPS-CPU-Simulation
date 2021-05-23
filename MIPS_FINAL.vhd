library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;



entity MIPS is
  
  port (
    
    
         
          
      Clock : in std_logic;

    ------------------------OUTPUT signals  
      
      --OUTPUTS OF IF-----
      
        Intruction_ID, PCPlus_4D: out std_logic_vector(31 downto 0) :=  (others =>'0');
        
    
          
      --OUTPUT OF ID -----
      
          Reg_wr_EX, Mem2reg_EX, Mem_wr_EX, ALU_src_EX, Reg_dis_EX : out std_logic := '0';
          ALU_ctrl_EX : out std_logic_vector (2 downto 0) := (others=>'0') ;
          
          --control signals for IF and ID stage 
          
          PcSr_out_ID           : out std_logic := '0';
          Jump_out_ID           : out std_logic_vector(1 downto 0) :=(others => '0');
          
          --PCBranchD signal from ID to IF to update PC 
          
          PC_branch_out_ID: out std_logic_vector (31 downto 0) := (others => '0');
          
          -- Operands and distination values from ID to EX 
          
          OP1_EX, OP2_EX, Sign_im_EX  : out std_logic_vector(31 downto 0) := (others=>'0');
          R_s_EX, R_t_EX, R_d_EX      : out std_logic_vector(4 downto 0) := (others=>'0');
          
          -- Values from ID to IF
    --      Sign_imm__out_ID            : out std_logic_vector(31 downto 0) :=  (others =>'0');
           
          
          --For Hazard unit 
          
          R_s_out_ID_HU, R_t_out_ID_HU : out std_logic_vector(4 downto 0):= (others => '0');
          Brch_out_ID_HU           : out std_logic := '0';
          
          
        --OUTPUT of EX------
        
        
        --Control signals going to memory stage ... with the write_data_m for dist
            
            Reg_wr_MEM, Mem2reg_MEM, Mem_wr_MEM     : out std_logic := '0';
            Write_Reg_MEM                           : out std_logic_vector(4 downto 0) := (others=>'0') ;
            ALU_out_MEM,  Write_Data_MEM            : out std_logic_vector(31 downto 0) := (others=>'0');
            
            --Signals going to hazard unit
            
            R_s_out_E_HU, R_t_out_E_HU               : out std_logic_vector(4 downto 0) := (others=>'0');
            Reg_wr_out_E_HU, Mem2reg_out_E_HU        : out std_logic := '0';  
            Write_Reg_out_E_HU                       : out std_logic_vector(4 downto 0) := (others=>'0');
            
            
          --OUTPUT FOR D_MEM---------------------------
          
          --Control signals going to WB 
            
            Reg_wr_WB, Mem2reg_WB        : out std_logic := '0';
            
            --Outputs going to WB
            Write_Reg_WB             : out std_logic_vector(4 downto 0) := (others=>'0') ;
            Data_mem_WB, ALU_out_WB  : out std_logic_vector(31 downto 0) := (others=>'0');
            
            --Signals going to HU 
            Write_Reg_DM_HU               : out std_logic_vector(4 downto 0) := (others=>'0');
            Reg_wr_DM_HU                  : out std_logic:= '0' ; 
            Mem2reg_DM_HU                 : out std_logic := '0' ;
            
            --Forward ALU output 
            
            ALU_out_Fwd_DM              : out std_logic_vector(31 downto 0) := (others=>'0');
            
            
            
            --OUTPUT FOR WB----------------------------
            
              Final_result_WB         : out std_logic_vector (31 downto 0) := (others=>'0'); --going to previous stages 
              Address_dis_WB       : out std_logic_vector (4 downto 0) := (others => '0');
              Register_write_WB    : out std_logic := '0';  --Control signal going to Decoding stage
              Register_write_HU    : out std_logic := '0'; --Going to hazard unit
              Address_dis_HU       : out std_logic_vector(4 downto 0):= (others => '0');
              
              --OUTPUT OF HU----------------------------  
              
              STALL_PC     :  out std_logic:= '0';   
              STALL_IF     :  out std_logic:= '0';   
              RESET_E      :  out std_logic:= '0'; 
              FwdAD, FwdBD :  out std_logic:= '0';
              FwdAE, FwdBE :  out std_logic_vector (1 downto 0):= (others => '0')
            
            
      
        );
        
end MIPS;


architecture structure of MIPS is
  
  --Components

component Instr_fetch is
  
  port (
    
      Clock   : in std_logic;
      En_PC   : in std_logic := '1';    --Stall F
      En_BUFF : in std_logic := '1';    --Stall D 
      Clr     : in std_logic := '0';
      MUX_sel : in std_logic := '0';
      NPC_IMM : in std_logic_vector(31 downto 0) :=  (others =>'0');   --PCbranchD
      
      Final_Instr_IF, Final_PC_IF: out std_logic_vector(31 downto 0) :=  (others =>'0')
      
        );
        
end component;

component Instr_decode is
  
  port (
    
    ----------------------------------------INPUT SIGNALS
    
    Clock   : in std_logic;
    Clr     : in std_logic := '0';
    
    -- From hazard
    
    Mux1_AD, Mux2_BD : in std_logic := '0';
    
    -- inputs coming from WB stage
    
    WB_Write_EN      : in std_logic := '0';
    WB_add_dis       : in std_logic_vector(4 downto 0);
    WB_Dat_2b_written: in std_logic_vector (31 downto 0);
    
    --inputs from IF and EX (First two are from IF and last one is from EX)
    
    Full_intruction, NPC_D, ALU_Result : in std_logic_vector (31 downto 0) := (others=>'0'); 
    
    -----------------------------------------OUTPUT SIGNALS
    
    
    --for controller output to the EX stage
    
    Reg_wrE, Mem2regE, Mem_wrE, ALU_srcE, Reg_disE : out std_logic := '0';
    ALU_ctrlE       : out std_logic_vector (2 downto 0) := (others=>'0') ;
    
    --control signals for IF and ID stage 
    
    PcSr_D          : out std_logic := '0';
    Jump_D          : out STD_LOGIC_VECTOR (1 downto 0):="00";
    
    --PCBranchD signal from ID to IF to update PC 
    
    PC_branch_D     : out std_logic_vector (31 downto 0);
    
    -- Operands and distination values from ID to EX 
    
    OP1_E, OP2_E, Sign_imE: out std_logic_vector(31 downto 0) := (others=>'0');
    R_sE, R_tE, R_dE      : out std_logic_vector(4 downto 0) := (others=>'0');
    
    -- Values from ID to IF
    --Sign_imm_D            : out std_logic_vector(31 downto 0) :=  (others =>'0');
     
    
    --For Hazard unit 
    
    R_sD, R_tD  : out std_logic_vector(4 downto 0);
    Brch_D      :out std_logic := '0'
    
  ); 
  
end component;


---------------------------

component Execution is
  
port

(
  

 -----------------------------------------Input SIGNALS
    
    Clock : in std_logic;
  
    
    --Control signals from ID stage
    
    Reg_wr_E, Mem2reg_E, Mem_wr_E,  ALU_srcE, Reg_dis_E: in std_logic := '0';
    ALU_ctrl_E                                         : in std_logic_vector (2 downto 0) := (others=>'0') ;
    
    --Control signals from Hazard unit to control muxes 
    
    Mux1_AE, Mux2_BE : in std_logic_vector (1 downto 0);
    
    
    --Operands coming from ID
    
    OP1_E, OP2_E, Sign_imE, ALU_result_mem, WB_output   : in std_logic_vector(31 downto 0) := (others=>'0');
    R_s_from_D, R_t_from_D, R_d_from_D                  : in std_logic_vector(4 downto 0) := (others=>'0');
    
    
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

end component;


---------------------------


component Data_mem is


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
  --Mem2reg_M_HU                 : out std_logic ;
  
  --Forward ALU output 
  
  ALU_out_Fwd              : out std_logic_vector(31 downto 0) := (others=>'0');
  
  Mem2reg_M                :  out std_logic:= '0' -----------------------------------------------------HERE              
  
  
  
);
end component;


---------------------------------
component WB is


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

end component ;


-----------------------------------------------

component Hazard_ctrl is
  
    Port ( 
      
      
      ----------------------------INPUT 
      
       Brnch_D     :  in std_logic:= '0' ; 
       Rs_D,Rt_D   :  in std_logic_vector (4 downto 0):= (others=>'0') ;
       
       Reg_wr_E    :  in std_logic:= '0' ;
       Mem2reg_E   :  in std_logic:= '0' ;
       Rs_E,Rt_E   :  in std_logic_vector (4 downto 0):= (others=>'0');
       Write_Reg_E :  in std_logic_vector (4 downto 0):= (others=>'0');
       
       Reg_wr_M    :  in std_logic:= '0';
       Write_Reg_M :  in std_logic_vector (4 downto 0) := (others=>'0');
       
       Reg_wr_W    :  in std_logic:= '0';
       Write_Reg_W :  in std_logic_vector (4 downto 0) := (others=>'0') ;
       
       Mem2reg_M   :  in std_logic:= '0'; 
       
       
       ---------------------------OUTPUT 
   
       Stall_PC: out std_logic:= '1' ;
       Stall_IF: out std_logic:= '1' ;
       Reset_E : out  std_logic:= '0';
       
       Fwd_AD: out std_logic:='0';
       Fwd_BD: out std_logic:='0';
       Fwd_AE: out std_logic_vector (1 downto 0) := (others=>'0') ;
       Fwd_BE: out std_logic_vector (1 downto 0) := (others=>'0') 
       
     );
       
end component;



-------------------------------------------------------------------------------------Signals for IF

signal Final_Instr_IF, Final_PC_IF : std_logic_vector (31 downto 0);

-------------------------------------------------------------------------------------signals for ID
signal  Reg_wrD, Mem2regD, Mem_wrD, ALU_srcD, Reg_disD :  std_logic;
signal  ALU_ctrlD      :  std_logic_vector (2 downto 0) ;  
signal  PcSr_D         :  std_logic ;                               --control signals for IF and ID stage 
signal  Jump_D         :  STD_LOGIC_VECTOR (1 downto 0);
signal  PC_branch_D    :  std_logic_vector (31 downto 0);           --PCBranchD signal from ID to IF to update PC  
signal OP1_D, OP2_D, Sign_imD :  std_logic_vector(31 downto 0) ;    -- Operands and distination values from ID to EX 
signal  R_sD, R_tD, R_dD      :  std_logic_vector(4 downto 0) ;     -- Operands and distination values from ID to EX 
signal R_sD_HU, R_tD_HU :  std_logic_vector(4 downto 0);            --For Hazard unit 
signal Brch_D           :  std_logic;                               --For Hazard unit 
    
    
------------------------------------------------------------------------------------  signals for Ex stage

signal Reg_wr_E, Mem2reg_E, Mem_wr_E :  std_logic;
signal Write_Reg_E                   :  std_logic_vector(4 downto 0);
signal ALU_out_E,  Write_Data_E      :  std_logic_vector(31 downto 0);

--Signals going to hazard unit

signal R_s_E, R_t_E                  :  std_logic_vector(4 downto 0);
signal Reg_wr_E_HU, Mem2reg_E_HU     :  std_logic;  
signal Write_Reg_E_HU                :  std_logic_vector(4 downto 0);
    
--------------------------------------------------------------------------------------signals for MEM stage

signal Reg_wr_M, Mem2reg_M          :  std_logic;
signal Write_Reg_M                  :  std_logic_vector(4 downto 0) ;
signal Data_mem_out_M, ALU_out_M    :  std_logic_vector(31 downto 0) ;
signal Write_Reg_M_HU               :  std_logic_vector(4 downto 0) ;
signal Reg_wr_M_HU                  :  std_logic ; 
signal Mem2reg_M_HU                 :  std_logic ;
signal ALU_out_Fwd_M                :  std_logic_vector(31 downto 0); 
  
--------------------------------------------------------------------------------------signals for WB 

    signal WB_Write_EN,Reg_wr_W_HU      : std_logic;
    signal WB_add_dis, WB_add_dis_HU    : std_logic_vector(4 downto 0);
    signal WB_Dat_2b_written            : std_logic_vector (31 downto 0);
    
    
--------------------------------------------------------------------------------------signals for WB    
    
signal       En_PC   :  std_logic;    --Stall F
signal       En_BUFF :  std_logic;    --Stall D 
signal       Clr     :  std_logic;
signal       flushE  :  std_logic; 
signal       Mux1_AD, Mux2_BD : std_logic;
signal       Mux1_AE, Mux2_BE :  std_logic_vector (1 downto 0);
     

begin 
  
 
  IF_st : Instr_fetch port map( Clock, En_PC,En_BUFF,PcSr_D, PcSr_D, PC_branch_D, 
                                Final_Instr_IF, Final_PC_IF); 
                                 
                                
    Intruction_ID    <= Final_Instr_IF;
    PCPlus_4D        <= Final_PC_IF ;                     
  
  ID_st : Instr_decode port map(Clock, flushE, Mux1_AD, Mux2_BD, WB_Write_EN, WB_add_dis,WB_Dat_2b_written, Final_Instr_IF, Final_PC_IF,ALU_out_Fwd_M, 
    
                                Reg_wrD, Mem2regD, Mem_wrD, ALU_srcD, Reg_disD,ALU_ctrlD,PcSr_D, Jump_D, PC_branch_D,OP1_D, OP2_D, Sign_imD, -- output for E stage
                                R_sD, R_tD, R_dD,             -- output for E stage
                                R_sD_HU, R_tD_HU, Brch_D);    --output for hazard

    
    Reg_wr_EX         <= Reg_wrD;
    Mem2reg_EX        <= Mem2regD;
    Mem_wr_EX         <= Mem_wrD;
    ALU_src_EX        <= ALU_srcD;
    Reg_dis_EX        <= Reg_disD;
    ALU_ctrl_EX       <= ALU_ctrlD;
    PcSr_out_ID       <= PcSr_D;
    Jump_out_ID       <= Jump_D;
    PC_branch_out_ID  <= PC_branch_D;
    OP1_EX            <= OP1_D;
    OP2_EX            <= OP2_D;
    Sign_im_EX        <= Sign_imD;
    R_s_EX            <= R_sD;
    R_t_EX            <= R_tD;
    R_d_EX            <= R_dD ;        
    R_s_out_ID_HU     <= R_sD_HU;
    R_t_out_ID_HU     <= R_tD_HU;
    Brch_out_ID_HU    <= Brch_D ;     
                                
                                
  
  E_st:  Execution  port map (Clock, Reg_wrD, Mem2regD, Mem_wrD, ALU_srcD, Reg_disD, ALU_ctrlD, Mux1_AE, Mux2_BE, OP1_D, OP2_D,Sign_imD, ALU_out_Fwd_M,
                              WB_Dat_2b_written,R_sD, R_tD, R_dD,
                              
                              
                              Reg_wr_E, Mem2reg_E, Mem_wr_E, Write_Reg_E, ALU_out_E,  Write_Data_E,    --output for DM
                              R_s_E, R_t_E , Reg_wr_E_HU, Mem2reg_E_HU, Write_Reg_E_HU);               --output for hazard


    Reg_wr_MEM     <= Reg_wr_E;
    Mem2reg_MEM    <= Mem2reg_E;
    Mem_wr_MEM     <= Mem_wr_E;
    Write_Reg_MEM  <= Write_Reg_E;                        
    ALU_out_MEM    <= ALU_out_E;
    Write_Data_MEM <= Write_Data_E; 
    
    R_s_out_E_HU        <= R_s_E;
    R_t_out_E_HU        <= R_t_E ;       
    Reg_wr_out_E_HU     <= Reg_wr_E_HU;
    Mem2reg_out_E_HU    <= Mem2reg_E_HU;    
    Write_Reg_out_E_HU  <= Write_Reg_E_HU;

  
  MEM_st:  Data_mem port map (Clock, Reg_wr_E, Mem2reg_E, Mem_wr_E, Write_Reg_E, ALU_out_E, Write_Data_E,
  
  
                              Reg_wr_M, Mem2reg_M, Write_Reg_M, Data_mem_out_M, ALU_out_M,  --output for WB
                              Write_Reg_M_HU, Reg_wr_M_HU,              --output for hazard
                              ALU_out_Fwd_M,Mem2reg_M_HU);              --output for forwarding 
    
    Reg_wr_WB           <=  Reg_wr_M;
    Mem2reg_WB          <=  Mem2reg_M;
    Write_Reg_WB        <=  Write_Reg_M  ;        
    Data_mem_WB         <=  Data_mem_out_M;
    ALU_out_WB          <=  ALU_out_M;
    
    Write_Reg_DM_HU     <=  Write_Reg_M_HU ;      
    Reg_wr_DM_HU        <=  Reg_wr_M_HU;      
    
    ALU_out_Fwd_DM      <=  ALU_out_Fwd_M ; 
    Mem2reg_DM_HU       <=  Mem2reg_M_HU;                      
                         
                                  
  WB_st:    WB port map       (Reg_wr_M, Mem2reg_M, Write_Reg_M, Data_mem_out_M, ALU_out_M,
  
   
                               WB_Dat_2b_written, WB_add_dis, --output data going to previos stages  
                               WB_Write_EN,                   --output of control 
                               Reg_wr_W_HU, WB_add_dis_HU);   --output for hazard
                               
                               
                               
     Final_result_WB     <= WB_Dat_2b_written;  
     Address_dis_WB      <= WB_add_dis;
     Register_write_WB   <= WB_Write_EN;
     Register_write_HU   <= Reg_wr_W_HU ;
     Address_dis_HU      <= WB_add_dis_HU;                          
                               
                               
   HU : Hazard_ctrl port map( Brch_D, R_sD_HU, R_tD_HU, Reg_wr_E_HU, Mem2reg_E_HU, R_s_E, R_t_E ,Write_Reg_E_HU, Reg_wr_M_HU, Write_Reg_M_HU,Reg_wr_W_HU,WB_add_dis_HU, Mem2reg_M_HU,
             
                              En_PC, En_BUFF, flushE, Mux1_AD, Mux2_BD, Mux1_AE, Mux2_BE);  --Output signals                                            
                                                                              
                              
      STALL_PC  <= En_PC;    
      STALL_IF  <= En_BUFF;      
      RESET_E   <= flushE;  
      FwdAD     <= Mux1_AD; 
      FwdBD     <= Mux2_BD; 
      FwdAE     <= Mux1_AE; 
      FwdBE     <= Mux2_BE; 

------------------------------------------------------------

end structure;



          