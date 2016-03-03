-- Design:
--	Testbench for the register file of the Freon core.
--
-- Authors:
--	Pietro Lorefice <pietro.lorefice@gmail.com>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file_tb is
end entity; -- reg_file_tb

architecture tb of reg_file_tb is
	constant T : time := 1 ns; -- arbitrary test time

	signal clk, arst, w_en : std_logic := '0';
	signal r_addr_1, r_addr_2, w_addr : std_logic_vector(4 downto 0) := (others => '0');
	signal r_data_1, r_data_2, w_data : std_logic_vector(31 downto 0) := (others => '0');

	signal tb_over : std_logic := '0';
begin
	-- unit under test
	uut : entity work.reg_file
		generic map (XLEN => 32, ALEN => 5)
		port map (
			clk      => clk,
			arst     => arst,
			w_en     => w_en,
			r_addr_1 => r_addr_1,
			r_addr_2 => r_addr_2,
			w_addr   => w_addr,
			r_data_1 => r_data_1,
			r_data_2 => r_data_2,
			w_data   => w_data
		);

	-- testbench clock
	clk <= not clk after T/2 when tb_over /='1' else '0';

	-- asynchronous reset
	arst <= '1', '0' after T;

	-- testbench
	tb_proc : process
	begin
		-- Make sure register r0 always contains zero
		r_addr_1 <= "00000"; wait for T;
		assert r_data_1 = X"00000000" report "R0 != 0" severity failure;
		
		-- Try to set R0
		wait until falling_edge(clk);
		w_addr <= "00000"; w_data <= X"ffffffff"; w_en <= '1';
		wait for T; w_en <= '0';
		assert r_data_1 = X"00000000" report "R0 != 0" severity failure;

		-- Set two random registers
		wait until falling_edge(clk);
		w_addr <= "01010"; w_data <= X"aabbccdd"; w_en <= '1';
		wait for T; w_en <= '0';

		wait until falling_edge(clk);
		w_addr <= "10101"; w_data <= X"11223344"; w_en <= '1';
		wait for T; w_en <= '0';

		-- Read back those registers
		r_addr_1 <= "01010"; r_addr_2 <= "10101"; wait for T;
		assert r_data_1 = X"aabbccdd" and r_data_2 = X"11223344"
			report "Wrong data read" severity failure;


		tb_over <= '1'; -- Terminate testbench
	end process; -- tb_proc

end architecture; -- reg_file_tb

