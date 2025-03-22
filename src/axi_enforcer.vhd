library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity axi_enforcer is
    generic (
    -- ENFORCEMENT GENERICS
    -- Thread ID Width
    C_M_AXI_ID_WIDTH    : integer    := 6;
    -- Width of User Write Address Bus
    C_M_AXI_AWUSER_WIDTH    : integer    := 10;
    -- Width of User Read Address Bus
    C_M_AXI_ARUSER_WIDTH    : integer    := 10;
    -- AxPROT values
    AXPROT_VALUE: std_logic_vector(2 downto 0) := "000";
    -- AxUSER value
    AXUSER_VALUE: std_logic_vector(9 downto 0) := "0000000000";
    -- AxQOS values
    AXQOS_VALUE: std_logic_vector(3 downto 0) := "0000";
    -- AxUSER value
    AXCACHE_VALUE: std_logic_vector(3 downto 0) := "0000";
      
    -- OTHER GENERICS
        -- Width of Address Bus
        C_M_AXI_ADDR_WIDTH    : integer    := 32;
        -- Width of Data Bus
        C_M_AXI_DATA_WIDTH    : integer    := 32;
    
    -- ENABLE
    Enable_AXPROT : boolean := true
    );
    port (
		
		--- MASTER PORTS ----
		
		-- Global Clock Signal.
		aclk	: in std_logic;
		-- Global Reset Singal. This Signal is Active Low
		aresetn	: in std_logic;
		-- Master Interface Write Address ID
		M_AXI_AWID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		-- Master Interface Write Address
		M_AXI_AWADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Burst length. The burst length gives the exact number of transfers in a burst
		M_AXI_AWLEN	: out std_logic_vector(7 downto 0);
		-- Burst size. This signal indicates the size of each transfer in the burst
		M_AXI_AWSIZE	: out std_logic_vector(2 downto 0);
		-- Burst type. The burst type and the size information, 
    -- determine how the address for each transfer within the burst is calculated.
		M_AXI_AWBURST	: out std_logic_vector(1 downto 0);
		-- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
		M_AXI_AWLOCK	: out std_logic;
		-- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
		M_AXI_AWCACHE	: out std_logic_vector(3 downto 0);
		-- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
		M_AXI_AWPROT	: out std_logic_vector(2 downto 0);
		-- Quality of Service, QoS identifier sent for each write transaction.
		M_AXI_AWQOS	: out std_logic_vector(3 downto 0);
		-- Optional User-defined signal in the write address channel.
		M_AXI_AWUSER	: out std_logic_vector(C_M_AXI_AWUSER_WIDTH-1 downto 0);
		-- Write address valid. This signal indicates that
    -- the channel is signaling valid write address and control information.
		M_AXI_AWVALID	: out std_logic;
		-- Write address ready. This signal indicates that
    -- the slave is ready to accept an address and associated control signals
		M_AXI_AWREADY	: in std_logic;
		-- Master Interface Write Data.
		M_AXI_WDATA	: out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Write strobes. This signal indicates which byte
    -- lanes hold valid data. There is one write strobe
    -- bit for each eight bits of the write data bus.
		M_AXI_WSTRB	: out std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
		-- Write last. This signal indicates the last transfer in a write burst.
		M_AXI_WLAST	: out std_logic;
		-- Write valid. This signal indicates that valid write
    -- data and strobes are available
		M_AXI_WVALID	: out std_logic;
		-- Write ready. This signal indicates that the slave
    -- can accept the write data.
		M_AXI_WREADY	: in std_logic;
		-- Master Interface Write Response.
		M_AXI_BID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		-- Write response. This signal indicates the status of the write transaction.
		M_AXI_BRESP	: in std_logic_vector(1 downto 0);
		-- Optional User-defined signal in the write response channel
		--M_AXI_BUSER	: in std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
		-- Write response valid. This signal indicates that the
    -- channel is signaling a valid write response.
		M_AXI_BVALID	: in std_logic;
		-- Response ready. This signal indicates that the master
    -- can accept a write response.
		M_AXI_BREADY	: out std_logic;
		-- Master Interface Read Address.
		M_AXI_ARID	: out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		-- Read address. This signal indicates the initial
    -- address of a read burst transaction.
		M_AXI_ARADDR	: out std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
		-- Burst length. The burst length gives the exact number of transfers in a burst
		M_AXI_ARLEN	: out std_logic_vector(7 downto 0);
		-- Burst size. This signal indicates the size of each transfer in the burst
		M_AXI_ARSIZE	: out std_logic_vector(2 downto 0);
		-- Burst type. The burst type and the size information, 
    -- determine how the address for each transfer within the burst is calculated.
		M_AXI_ARBURST	: out std_logic_vector(1 downto 0);
		-- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
		M_AXI_ARLOCK	: out std_logic;
		-- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
		M_AXI_ARCACHE	: out std_logic_vector(3 downto 0);
		-- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
		M_AXI_ARPROT	: out std_logic_vector(2 downto 0);
		-- Quality of Service, QoS identifier sent for each read transaction
		M_AXI_ARQOS	: out std_logic_vector(3 downto 0);
		-- Optional User-defined signal in the read address channel.
		M_AXI_ARUSER	: out std_logic_vector(C_M_AXI_ARUSER_WIDTH-1 downto 0);
		-- Write address valid. This signal indicates that
    -- the channel is signaling valid read address and control information
		M_AXI_ARVALID	: out std_logic;
		-- Read address ready. This signal indicates that
    -- the slave is ready to accept an address and associated control signals
		M_AXI_ARREADY	: in std_logic;
		-- Read ID tag. This signal is the identification tag
    -- for the read data group of signals generated by the slave.
		M_AXI_RID	: in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
		-- Master Read Data
		M_AXI_RDATA	: in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
		-- Read response. This signal indicates the status of the read transfer
		M_AXI_RRESP	: in std_logic_vector(1 downto 0);
		-- Read last. This signal indicates the last transfer in a read burst
		M_AXI_RLAST	: in std_logic;
		-- Read valid. This signal indicates that the channel
    -- is signaling the required read data.
		M_AXI_RVALID	: in std_logic;
		-- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
		M_AXI_RREADY	: out std_logic;
		
		-- ---- MASTER INVERTED PORTS (SLAVE) ----

    -- AWID
    S_AXI_AWID : in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    -- Master Interface Write Address
    S_AXI_AWADDR : in std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    -- Burst length. The burst length gives the exact number of transfers in a burst
    S_AXI_AWLEN : in std_logic_vector(7 downto 0);
    -- Burst size. This signal indicates the size of each transfer in the burst
    S_AXI_AWSIZE : in std_logic_vector(2 downto 0);
    -- Burst type. The burst type and the size information,
    -- determine how the address for each transfer within the burst is calculated.
    S_AXI_AWBURST : in std_logic_vector(1 downto 0);
    -- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
    S_AXI_AWLOCK : in std_logic;
    -- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
    S_AXI_AWCACHE : in std_logic_vector(3 downto 0);
    -- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
    S_AXI_AWPROT : in std_logic_vector(2 downto 0);
    -- Quality of Service, QoS identifier sent for each write transaction.
    S_AXI_AWQOS : in std_logic_vector(3 downto 0);
    -- Write address valid. This signal indicates that
    -- the channel is signaling valid write address and control information.
    S_AXI_AWVALID : in std_logic;
    -- Write address ready. This signal indicates that
    -- the slave is ready to accept an address and associated control signals
    S_AXI_AWREADY : out std_logic;
    -- Master Interface Write Data.
    S_AXI_WDATA : in std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    -- Write strobes. This signal indicates which byte
    -- lanes hold valid data. There is one write strobe
    -- bit for each eight bits of the write data bus.
    S_AXI_WSTRB : in std_logic_vector(C_M_AXI_DATA_WIDTH/8-1 downto 0);
    -- Write last. This signal indicates the last transfer in a write burst.
    S_AXI_WLAST : in std_logic;
    -- Write valid. This signal indicates that valid write
    -- data and strobes are available
    S_AXI_WVALID : in std_logic;
    -- Write ready. This signal indicates that the slave
    -- can accept the write data.
    S_AXI_WREADY : out std_logic;
    -- Master Interface Write Response.
    S_AXI_BID : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    -- Write response. This signal indicates the status of the write transaction.
    S_AXI_BRESP : out std_logic_vector(1 downto 0);
    -- Optional User-defined signal in the write response channel
    --S_AXI_BUSER : out std_logic_vector(C_M_AXI_BUSER_WIDTH-1 downto 0);
    -- Write response valid. This signal indicates that the
    -- channel is signaling a valid write response.
    S_AXI_BVALID : out std_logic;
    -- Response ready. This signal indicates that the master
    -- can accept a write response.
    S_AXI_BREADY : in std_logic;
    -- ARID
    S_AXI_ARID : in std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    -- Read address. This signal indicates the initial
    -- address of a read burst transaction.
    S_AXI_ARADDR : in std_logic_vector(C_M_AXI_ADDR_WIDTH-1 downto 0);
    -- Burst length. The burst length gives the exact number of transfers in a burst
    S_AXI_ARLEN : in std_logic_vector(7 downto 0);
    -- Burst size. This signal indicates the size of each transfer in the burst
    S_AXI_ARSIZE : in std_logic_vector(2 downto 0);
    -- Burst type. The burst type and the size information,
    -- determine how the address for each transfer within the burst is calculated.
    S_AXI_ARBURST : in std_logic_vector(1 downto 0);
    -- Lock type. Provides additional information about the
    -- atomic characteristics of the transfer.
    S_AXI_ARLOCK : in std_logic;
    -- Memory type. This signal indicates how transactions
    -- are required to progress through a system.
    S_AXI_ARCACHE : in std_logic_vector(3 downto 0);
    -- Protection type. This signal indicates the privilege
    -- and security level of the transaction, and whether
    -- the transaction is a data access or an instruction access.
    S_AXI_ARPROT : in std_logic_vector(2 downto 0);
    -- Quality of Service, QoS identifier sent for each read transaction
    S_AXI_ARQOS : in std_logic_vector(3 downto 0);
    -- Write address valid. This signal indicates that
    -- the channel is signaling valid read address and control information
    S_AXI_ARVALID : in std_logic;
    -- Read address ready. This signal indicates that
    -- the slave is ready to accept an address and associated control signals
    S_AXI_ARREADY : out std_logic;
    -- Read ID tag. This signal is the identification tag
    -- for the read data group of signals generated by the slave.
    S_AXI_RID : out std_logic_vector(C_M_AXI_ID_WIDTH-1 downto 0);
    -- Master Read Data
    S_AXI_RDATA : out std_logic_vector(C_M_AXI_DATA_WIDTH-1 downto 0);
    -- Read response. This signal indicates the status of the read transfer
    S_AXI_RRESP : out std_logic_vector(1 downto 0);
    -- Read last. This signal indicates the last transfer in a read burst
    S_AXI_RLAST : out std_logic;
    -- Read valid. This signal indicates that the channel
    -- is signaling the required read data.
    S_AXI_RVALID : out std_logic;
    -- Read ready. This signal indicates that the master can
    -- accept the read data and response information.
    S_AXI_RREADY : in std_logic
    );
end entity axi_enforcer;


architecture implementation of axi_enforcer  is

  -- FUNCTIONS
  -- enforce the axprot depending on the option
  function enforce_axprot(input_axprot: std_logic_vector) return std_logic_vector is
  begin
    if Enable_AXPROT then
      return AXPROT_VALUE;
    else
      return input_axprot;
    end if;
  end enforce_axprot;

begin
	-- ENFORCEMENT
	
	-- Master Interface Write Address ID assignment
	M_AXI_AWUSER    <= AXUSER_VALUE;
	M_AXI_ARUSER    <= AXUSER_VALUE;
	M_AXI_AWPROT    <= enforce_axprot(S_AXI_AWPROT);
	M_AXI_ARPROT    <= enforce_axprot(S_AXI_ARPROT);
  M_AXI_AWQOS     <= AXQOS_VALUE;
  M_AXI_ARQOS     <= AXQOS_VALUE;
  M_AXI_ARCACHE   <= AXCACHE_VALUE;
  M_AXI_ARCACHE   <= AXCACHE_VALUE;
	
	-- OTHER SIGNALS
	
	-- AWID
	M_AXI_AWID <= S_AXI_AWID;
	
	-- ARID
	M_AXI_ARID <= S_AXI_ARID;

  -- Master Interface Write Address assignment
  M_AXI_AWADDR <= S_AXI_AWADDR;

  -- Burst length assignment
  M_AXI_AWLEN <= S_AXI_AWLEN;

  -- Burst size assignment
  M_AXI_AWSIZE <= S_AXI_AWSIZE;

  -- Burst type assignment
  M_AXI_AWBURST <= S_AXI_AWBURST;

  -- Lock type assignment
  M_AXI_AWLOCK <= S_AXI_AWLOCK;

  -- Write address valid assignment
  M_AXI_AWVALID <= S_AXI_AWVALID;

  -- Write address ready assignment
  S_AXI_AWREADY <= M_AXI_AWREADY;

  -- Master Interface Write Data assignment
  M_AXI_WDATA <= S_AXI_WDATA;

  -- Write strobes assignment
  M_AXI_WSTRB <= S_AXI_WSTRB;

  -- Write last assignment
  M_AXI_WLAST <= S_AXI_WLAST;

  -- Write valid assignment
  M_AXI_WVALID <= S_AXI_WVALID;

  -- Write ready assignment
  S_AXI_WREADY <= M_AXI_WREADY;

  -- Master Interface Write Response assignment
  S_AXI_BID <= M_AXI_BID;

  -- Write response assignment
  S_AXI_BRESP <= M_AXI_BRESP;

  -- Write response valid assignment
  S_AXI_BVALID <= M_AXI_BVALID;

  -- Response ready assignment
  M_AXI_BREADY <= S_AXI_BREADY;

  -- Read address assignment
  M_AXI_ARADDR <= S_AXI_ARADDR;

  -- Burst length assignment
  M_AXI_ARLEN <= S_AXI_ARLEN;

  -- Burst size assignment
  M_AXI_ARSIZE <= S_AXI_ARSIZE;

  -- Burst type assignment
  M_AXI_ARBURST <= S_AXI_ARBURST;

  -- Lock type assignment
  M_AXI_ARLOCK <= S_AXI_ARLOCK;

  -- Read address valid assignment
  M_AXI_ARVALID<= S_AXI_ARVALID;

  -- Read address ready assignment
  S_AXI_ARREADY <= M_AXI_ARREADY;

  -- Read ID tag assignment
  S_AXI_RID <= M_AXI_RID;

  -- Master Read Data assignment
  S_AXI_RDATA <= M_AXI_RDATA;

  -- Read response assignment
  S_AXI_RRESP <= M_AXI_RRESP;

  -- Read last assignment
  S_AXI_RLAST <= M_AXI_RLAST;

  -- Read valid assignment
  S_AXI_RVALID <= M_AXI_RVALID;

  -- Read ready assignment
  M_AXI_RREADY <= S_AXI_RREADY;

end architecture implementation;