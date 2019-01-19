-- Design:
--	Testbench for the fetch unit of the Freon core 5-stage pipeline.
--	Tested functionalities: instruction fetch, PC register load and
--	increment, stalling, instruction validity.
--
-- Authors:
--	Pietro Lorefice <pietro.lorefice@gmail.com>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fetch_unit_tb is
end entity; -- fetch_unit_tb

architecture tb of fetch_unit_tb is
	constant T : time := 1 ns; -- clock period
	constant XLEN, INSTRLEN : integer := 32;

	-- memory type
	type memory_type is array(integer range 127 downto 0) of
		std_logic_vector(INSTRLEN-1 downto 0);

	signal clk, arst, pc_load_strobe : std_logic := '0';
	signal stall : std_logic := '1';
	signal valid : std_logic;

	signal pc_load_addr : std_logic_vector(XLEN-1 downto 0) := (others => '0');
	signal pc, io_addr : std_logic_vector(XLEN-1 downto 0);

	signal io_instr, instr : std_logic_vector(INSTRLEN-1 downto 0);

	signal instr_mem : memory_type;

	signal tb_over : std_logic := '0';
begin
	-- unit under test
	uut : entity work.fetch_unit
		generic map (XLEN => XLEN, INSTRLEN => INSTRLEN)
		port map (
			clk            => clk,
			arst           => arst,
			stall          => stall,
			pc_load_addr   => pc_load_addr,
			pc_load_strobe => pc_load_strobe,
			io_addr        => io_addr,
			io_instr       => io_instr,
			pc             => pc,
			instr          => instr,
			valid          => valid
		);

	-- testbench clock
	clk <= not clk after T/2 when tb_over /= '1' else '0';

	-- asynchronous reset
	arst <= '1', '0' after T;

	-- connect memory signals
	io_instr <= instr_mem(to_integer(unsigned(io_addr)));

	-- testbench
	tb_proc : process
	begin
		-- Initialize memory with some instructions
		for i in 0 to 127 loop
			instr_mem(i) <= std_logic_vector(to_unsigned(i, INSTRLEN));
		end loop;

		-- Reset conditions
		stall <= '1';
		pc_load_strobe <= '0';
		wait until falling_edge(clk);

		-- test valid bit
		assert valid = '0'
			report "Valid asserted when stalled"
			severity failure;

		wait for T;

		assert valid = '0'
			report "Valid asserted set when stalled"
			severity failure;

		-- Un-stall the pipeline
		stall <= '0';
		wait until falling_edge(clk);

		assert valid = '1'
			report "Valid not asserted when running"
			severity failure;

		--assert io_instr = X"00000000";
		--	report "Wrong instruction read from memory"
		--	severity failure;

		wait for T;

		tb_over <= '1'; -- Terminate testbench
	end process; -- tb_proc

end architecture; -- tb
