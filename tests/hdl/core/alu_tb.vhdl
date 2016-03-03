-- Design:
--	Testbench for the Arithmetic Logic Unit of the Freon core.
--	Tests taken from: https://github.com/riscv/riscv-tests
--
-- Authors:
--	Pietro Lorefice <pietro.lorefice@gmail.com>

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
		assert res = X"00000000" report "[ADD] Wrong result" severity failure;

		op1 <= X"00000001"; op2 <= X"00000001"; wait for T;
		assert res = X"00000002" report "[ADD] Wrong result" severity failure;

		op1 <= X"00000003"; op2 <= X"00000007"; wait for T;
		assert res = X"0000000A" report "[ADD] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"ffff8000" report "[ADD] Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"00000000"; wait for T;
		assert res = X"80000000" report "[ADD] Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"7fff8000" report "[ADD] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"00007fff" report "[ADD] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00000000"; wait for T;
		assert res = X"7fffffff" report "[ADD] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00007fff"; wait for T;
		assert res = X"80007ffe" report "[ADD] Wrong result" severity failure;


		op1 <= X"80000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"80007fff" report "[ADD] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"ffff8000"; wait for T;
		assert res = X"7fff7fff" report "[ADD] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffffffff"; wait for T;
		assert res = X"ffffffff" report "[ADD] Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"00000001"; wait for T;
		assert res = X"00000000" report "[ADD] Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"ffffffff"; wait for T;
		assert res = X"fffffffe" report "[ADD] Wrong result" severity failure;


		op1 <= X"00000001"; op2 <= X"7fffffff"; wait for T;
		assert res = X"80000000" report "[ADD] Wrong result" severity failure;


		--##############################################################
		--                          [SUB]
		--##############################################################
		opsel <= "000"; ctrl <= '1';


		op1 <= X"00000000"; op2 <= X"00000000"; wait for T;
		assert res = X"00000000" report "[SUB] Wrong result" severity failure;

		op1 <= X"00000001"; op2 <= X"00000001"; wait for T;
		assert res = X"00000000" report "[SUB] Wrong result" severity failure;

		op1 <= X"00000003"; op2 <= X"00000007"; wait for T;
		assert res = X"fffffffc" report "[SUB] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"00008000" report "[SUB] Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"00000000"; wait for T;
		assert res = X"80000000" report "[SUB] Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"80008000" report "[SUB] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"ffff8001" report "[SUB] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00000000"; wait for T;
		assert res = X"7fffffff" report "[SUB] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00007fff"; wait for T;
		assert res = X"7fff8000" report "[SUB] Wrong result" severity failure;


		op1 <= X"80000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"7fff8001" report "[SUB] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"ffff8000"; wait for T;
		assert res = X"80007fff" report "[SUB] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffffffff"; wait for T;
		assert res = X"00000001" report "[SUB] Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"00000001"; wait for T;
		assert res = X"fffffffe" report "[SUB] Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"ffffffff"; wait for T;
		assert res = X"00000000" report "[SUB] Wrong result" severity failure;


		--##############################################################
		--                          [SLT]
		--##############################################################
		opsel <= "010"; ctrl <= '0';


		op1 <= X"00000000"; op2 <= X"00000000"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;

		op1 <= X"00000001"; op2 <= X"00000001"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;

		op1 <= X"00000003"; op2 <= X"00000007"; wait for T;
		assert res = X"00000001" report "[SLT] Wrong result" severity failure;

		op1 <= X"00000007"; op2 <= X"00000003"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"00000000"; wait for T;
		assert res = X"00000001" report "[SLT] Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"00000001" report "[SLT] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"00000001" report "[SLT] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00000000"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00007fff"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;


		op1 <= X"80000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"00000001" report "[SLT] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"ffff8000"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffffffff"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"00000001"; wait for T;
		assert res = X"00000001" report "[SLT] Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"ffffffff"; wait for T;
		assert res = X"00000000" report "[SLT] Wrong result" severity failure;


		--##############################################################
		--                          [SLTU]
		--##############################################################
		opsel <= "011"; ctrl <= '0';


		op1 <= X"00000000"; op2 <= X"00000000"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;

		op1 <= X"00000001"; op2 <= X"00000001"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;

		op1 <= X"00000003"; op2 <= X"00000007"; wait for T;
		assert res = X"00000001" report "[SLTU] Wrong result" severity failure;

		op1 <= X"00000007"; op2 <= X"00000003"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"00000001" report "[SLTU] Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"00000000"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;

		op1 <= X"80000000"; op2 <= X"ffff8000"; wait for T;
		assert res = X"00000001" report "[SLTU] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"00000001" report "[SLTU] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00000000"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"00007fff"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;


		op1 <= X"80000000"; op2 <= X"00007fff"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;

		op1 <= X"7fffffff"; op2 <= X"ffff8000"; wait for T;
		assert res = X"00000001" report "[SLTU] Wrong result" severity failure;


		op1 <= X"00000000"; op2 <= X"ffffffff"; wait for T;
		assert res = X"00000001" report "[SLTU] Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"00000001"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;

		op1 <= X"ffffffff"; op2 <= X"ffffffff"; wait for T;
		assert res = X"00000000" report "[SLTU] Wrong result" severity failure;


		--##############################################################
		--                          [AND]
		--##############################################################
		opsel <= "111"; ctrl <= '0';


		op1 <= X"ff00ff00"; op2 <= X"0f0f0f0f"; wait for T;
		assert res = X"0f000f00" report "[AND] Wrong result" severity failure;

		op1 <= X"0ff00ff0"; op2 <= X"f0f0f0f0"; wait for T;
		assert res = X"00f000f0" report "[AND] Wrong result" severity failure;

		op1 <= X"00ff00ff"; op2 <= X"0f0f0f0f"; wait for T;
		assert res = X"000f000f" report "[AND] Wrong result" severity failure;

		op1 <= X"f00ff00f"; op2 <= X"f0f0f0f0"; wait for T;
		assert res = X"f000f000" report "[AND] Wrong result" severity failure;


		--##############################################################
		--                          [OR]
		--##############################################################
		opsel <= "110"; ctrl <= '0';


		op1 <= X"ff00ff00"; op2 <= X"0f0f0f0f"; wait for T;
		assert res = X"ff0fff0f" report "[OR] Wrong result" severity failure;

		op1 <= X"0ff00ff0"; op2 <= X"f0f0f0f0"; wait for T;
		assert res = X"fff0fff0" report "[OR] Wrong result" severity failure;

		op1 <= X"00ff00ff"; op2 <= X"0f0f0f0f"; wait for T;
		assert res = X"0fff0fff" report "[OR] Wrong result" severity failure;

		op1 <= X"f00ff00f"; op2 <= X"f0f0f0f0"; wait for T;
		assert res = X"f0fff0ff" report "[OR] Wrong result" severity failure;


		--##############################################################
		--                          [XOR]
		--##############################################################
		opsel <= "100"; ctrl <= '0';


		op1 <= X"ff00ff00"; op2 <= X"0f0f0f0f"; wait for T;
		assert res = X"f00ff00f" report "[XOR] Wrong result" severity failure;

		op1 <= X"0ff00ff0"; op2 <= X"f0f0f0f0"; wait for T;
		assert res = X"ff00ff00" report "[XOR] Wrong result" severity failure;

		op1 <= X"00ff00ff"; op2 <= X"0f0f0f0f"; wait for T;
		assert res = X"0ff00ff0" report "[XOR] Wrong result" severity failure;

		op1 <= X"f00ff00f"; op2 <= X"f0f0f0f0"; wait for T;
		assert res = X"00ff00ff" report "[XOR] Wrong result" severity failure;


		wait; -- Terminate testbench
	end process; -- tb_proc

end architecture; -- tb
