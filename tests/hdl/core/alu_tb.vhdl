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
		--##############################################################
		--                          [ADD]
		--##############################################################
		opsel <= "000"; ctrl <= '0';

		op1 <= X"00000000"; op2 <= X"00000000"; wait for T;
		assert res = X"00000000" report "Wrong result" severity failure;

		op1 <= X"00000001"; op2 <= X"00000001"; wait for T;
		assert res = X"00000002" report "Wrong result" severity failure;

		op1 <= X"00000003"; op2 <= X"00000007"; wait for T;
		assert res = X"0000000A" report "Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"ffff8000" report "Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"00000000"; wait for T;
		assert res = X"80000000" report "Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"7fff8000" report "Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"00007fff" report "Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00000000"; wait for T;
		assert res = X"7fffffff" report "Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00007fff"; wait for T;
		assert res = X"80007ffe" report "Wrong result" severity failure;


		op1 <= X"80000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"80007fff" report "Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"ffff8000"; wait for T;
		assert res = X"7fff7fff" report "Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffffffff"; wait for T;
		assert res = X"ffffffff" report "Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"00000001"; wait for T;
		assert res = X"00000000" report "Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"ffffffff"; wait for T;
		assert res = X"fffffffe" report "Wrong result" severity failure;


		op1 <= X"00000001"; op2 <= X"7fffffff"; wait for T;
		assert res = X"80000000" report "Wrong result" severity failure;


		--##############################################################
		--                          [SUB]
		--##############################################################
		opsel <= "000"; ctrl <= '1';

		op1 <= X"00000000"; op2 <= X"00000000"; wait for T;
		assert res = X"00000000" report "Wrong result" severity failure;

		op1 <= X"00000001"; op2 <= X"00000001"; wait for T;
		assert res = X"00000000" report "Wrong result" severity failure;

		op1 <= X"00000003"; op2 <= X"00000007"; wait for T;
		assert res = X"fffffffc" report "Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"00008000" report "Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"00000000"; wait for T;
		assert res = X"80000000" report "Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"80008000" report "Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"ffff8001" report "Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00000000"; wait for T;
		assert res = X"7fffffff" report "Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00007fff"; wait for T;
		assert res = X"7fff8000" report "Wrong result" severity failure;


		op1 <= X"80000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"7fff8001" report "Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"ffff8000"; wait for T;
		assert res = X"80007fff" report "Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffffffff"; wait for T;
		assert res = X"00000001" report "Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"00000001"; wait for T;
		assert res = X"fffffffe" report "Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"ffffffff"; wait for T;
		assert res = X"00000000" report "Wrong result" severity failure;


		wait; -- Terminate testbench
	end process; -- tb_proc

end architecture; -- tb
