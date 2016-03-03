-- Design:
--	Arithmetic Logic unit for the Freon core.
--
-- Authors:
--	Pietro Lorefice <pietro.lorefice@gmail.com>

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
		op1, op2	: in std_logic_vector(XLEN-1 downto 0);
		res		: out std_logic_vector(XLEN-1 downto 0)
	);
end entity ; -- alu

architecture beh of alu is
	signal op1_s, op2_s : signed(XLEN-1 downto 0) := (others => '0');
	signal op1_u, op2_u : unsigned(XLEN-1 downto 0) := (others => '0');
begin
	-- Connecting internal signals
	op1_s <= signed(op1);
	op2_s <= signed(op2);

	op1_u <= unsigned(op1);
	op2_u <= unsigned(op2);

	-- ALU arithmetic operators
	process (op1_s, op2_s, op1_u, op2_u, op1, op2, opsel, ctrl)
	begin
		res <= (others => '0');

		case opsel(2 downto 0) is
			when "000" => -- ADD/SUB
				if (ctrl = '0') then
					res <= std_logic_vector(op1_s + op2_s);
				else
					res <= std_logic_vector(op1_s - op2_s);
				end if;

			when "010" => -- SLT
				if (op1_s < op2_s) then
					res(0) <= '1';
				end if;

			when "011" => -- SLTU
				if (op1_u < op2_u) then
					res(0) <= '1';
				end if;

			when "100" => -- XOR
				res <= op1 xor op2;

			when "110" => -- OR
				res <= op1 or op2;

			when "111" => -- AND
				res <= op1 and op2;

			when others => -- irrelevant, not managed by ALU
				res <= (others => '0');
		end case;
	end process;

end architecture ; -- beh
