-- Design: Arithmetic Logic unit

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	generic (
		XLEN	: integer := 32		-- # data bits
	);
	port (
		opsel		: in std_logic_vector(2 downto 0);
		ctrl		: in std_logic;
		a, b		: in std_logic_vector(XLEN-1 downto 0);
		q		: out std_logic_vector(XLEN-1 downto 0)
	);
end entity ; -- alu

architecture beh of alu is
	signal a_u, b_u, q_u : unsigned(XLEN-1 downto 0) := (others => '0');
	signal a_s, b_s, q_s : signed(XLEN-1 downto 0) := (others => '0');
begin

end architecture ; -- beh
