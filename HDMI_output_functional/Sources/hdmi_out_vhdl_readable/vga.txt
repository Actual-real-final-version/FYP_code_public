----------------------------------------------------------------------------------
-- Engineer:       Mike Field <hamster@snap.net.nz>
-- Module Name:    ColourTest - Behavioral 
-- Description:    Generates an 640x480 VGA showing all colours
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity vga is
   generic (
      hRez       : natural := 640;	     --horizontal resolution
      hStartSync : natural := 656;
      hEndSync   : natural := 752;
      hMaxCount  : natural := 800;
      hsyncActive : std_logic := '0';
		
      vRez       : natural := 480;       --vertical resolution
      vStartSync : natural := 490;
      vEndSync   : natural := 492;
      vMaxCount  : natural := 525;
      vsyncActive : std_logic := '1'
   );

    Port ( pixelClock : in  STD_LOGIC;
           Red        : out STD_LOGIC_VECTOR (7 downto 0);
           Green      : out STD_LOGIC_VECTOR (7 downto 0);
           Blue       : out STD_LOGIC_VECTOR (7 downto 0);
           hSync      : out STD_LOGIC;
           vSync      : out STD_LOGIC;
           blank      : out STD_LOGIC);                     --flag which tells if pixel contains data, 1 = blank and 0 = contains data
end vga;

architecture Behavioral of vga is
   type reg is record
      hCounter : std_logic_vector(11 downto 0);
      vCounter : std_logic_vector(11 downto 0);

      red      : std_logic_vector(7 downto 0);
      green    : std_logic_vector(7 downto 0);
      blue     : std_logic_vector(7 downto 0);

      hSync    : std_logic;
      vSync    : std_logic;
      blank    : std_logic;		
   end record;

   signal r : reg := ((others=>'0'), (others=>'0'),                     -- r is the temp storage reg that passes data to outputs
                      (others=>'0'), (others=>'0'), (others=>'0'), 
                      '0', '0', '0');
   signal n : reg;                                                      -- n is the same as r, but this gets edited
begin
   -- Assign the outputs to r
   hSync <= r.hSync;
   vSync <= r.vSync;
   Red   <= r.red;
   Green <= r.green;
   Blue  <= r.blue;
   blank <= r.blank;
   
   process(r,n)         --updates when n or r updates
   begin
      n <= r;                       -- load saved data from r into n
      n.hSync <= not hSyncActive;   -- disable the sync flags until sync state is realised
      n.vSync <= not vSyncActive;      

      -- Count the lines and rows, reset to zero if above MaxCount, otherwise increment  
      if r.hCounter = hMaxCount-1 then
         n.hCounter <= (others => '0');
         if r.vCounter = vMaxCount-1 then
            n.vCounter <= (others => '0');
         else
            n.vCounter <= r.vCounter+1;
         end if;
      else
         n.hCounter <= r.hCounter+1;
      end if;

        --set colours if within the resolution window
      if r.hCounter  < hRez and r.vCounter  < vRez then
         n.red   <= n.hCounter(5 downto 0) & n.hCounter(5 downto 4);
         n.green <= n.hCounter(7 downto 0) xor n.vCounter(7 downto 0);
         n.blue  <= n.vCounter(7 downto 0) and n.hCounter(7 downto 0);
         n.blank <= '0';
         
         --otherwise declare pixel blank
      else
         n.red   <= (others => '0');
         n.green <= (others => '0');
         n.blue  <= (others => '0');
         n.blank <= '1';
      end if;
      
      -- must need to sync at the end of each line and column with a pulse of 0's for rows and 1's for columns
      -- Are we in the hSync pulse?
      if r.hCounter >= hStartSync and r.hCounter < hEndSync then
         n.hSync <= hSyncActive;
      end if;

      -- Are we in the vSync pulse?
      if r.vCounter >= vStartSync and r.vCounter < vEndSync then
         n.vSync <= vSyncActive; 
      end if;
   end process;

    --pixelClock updates r to our newly edited n value
   process(pixelClock,n)
   begin
      if rising_edge(pixelClock)
      then
         r <= n;
      end if;
   end process;
end Behavioral;
