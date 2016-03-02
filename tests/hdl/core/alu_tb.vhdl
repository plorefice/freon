-- Design: Testbench for the Arithmetic Logic Unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is
end entity; -- alu_tb

architecture tb of alu_tb is
	constant T : time := 1 ns; -- arbitrary test time

	signal opsel : std_logic_vector(2 downto 0) := (others => '0');
	signal ctrl : std_logic := '0';
	signal op1, op2, res : std_logic_vector(31 downto 0) := (others => '0');
begin
	-- unit under test
	uut : entity work.alu
		generic map (XLEN => 32)
		port map (
			opsel => opsel,
			ctrl => ctrl,
			op1 => op1,
			op2 => op2,
			res => res
		);

	-- testbench process
	tb_proc : process
	begin
		--###########################
		--           [ADD]
		--###########################
		opsel <= "000"; ctrl <= '0';

		op1 <= X"00000000"; op2 <= X"00000000";
		wait for T;
		assert res = X"00000000" report "Wrong result" severity failure;

		wait for T;
		assert false report "Simulation over" severity failure;
	end process; -- tb_proc

end architecture; -- tb
