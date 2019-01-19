-- Design:
--	Fetch unit for the Freon core 5-stage pipeline.
--	This unit fetches and temporary stores instructions from the program
--	memory, and later passes them on to the decoding unit of the pipeline
--	to be executed.
--
-- Authors:
--	Pietro Lorefice <pietro.lorefice@gmail.com>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch_unit is
	generic (
		XLEN		: integer := 32; -- # address bits
		INSTRLEN	: integer := 32	-- # instruction bits
	);
	port (
		clk, arst	: in std_logic;
		stall		: in std_logic;

		-- PC load address logic
		pc_load_addr	: in std_logic_vector(XLEN-1 downto 0);
		pc_load_strobe	: in std_logic;

		-- Instruction fetch logic
		io_instr	: in std_logic_vector(INSTRLEN-1 downto 0);
		io_addr		: out std_logic_vector(XLEN-1 downto 0);

		-- Next pipeline stage logic
		pc		: out std_logic_vector(XLEN-1 downto 0);
		instr		: out std_logic_vector(INSTRLEN-1 downto 0);
		valid		: out std_logic
	);
end entity; -- fetch_unit

architecture rtl of fetch_unit is
	signal pc_reg, pc_next : unsigned(XLEN-1 downto 0) := (others => '0');
	signal instr_reg, instr_next : std_logic_vector(XLEN-1 downto 0) := (others => '0');
	signal valid_reg, valid_next : std_logic := '0';

	signal load_ctrl : std_logic_vector(1 downto 0);
begin
	-- Register updates
	process (clk, arst)
	begin
		if (arst = '1') then
			pc_reg <= (others => '0');
			instr_reg <= (others => '0');
			valid_reg <= '0';
		elsif rising_edge(clk) then
			pc_reg <= pc_next;
			instr_reg <= instr_next;
			valid_reg <= valid_next;
		end if;
	end process;

	-- Program counter update logic
	load_ctrl <= stall & pc_load_strobe;
	with load_ctrl select pc_next <= 
		pc_reg + 4             when "00",
		unsigned(pc_load_addr) when "01",
		pc_reg                 when others;

	-- Invalid instruction when stalling
	valid_next <= not stall;	

	-- For now we assume that the instruction is always ready 
	instr_next <= io_instr;

	-- Output signals
	io_addr <= std_logic_vector(pc_reg);

	pc <= std_logic_vector(pc_reg);
	instr <= instr_reg;
	valid <= valid_reg;

end architecture; -- rtl
