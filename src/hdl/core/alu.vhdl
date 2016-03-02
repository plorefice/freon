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
		op1, op2	: in std_logic_vector(XLEN-1 downto 0);
		res		: out std_logic_vector(XLEN-1 downto 0)
	);
end entity ; -- alu

architecture beh of alu is
	signal op1_u, op2_u, res_u : unsigned(XLEN-1 downto 0) := (others => '0');
	signal op1_s, op2_s, res_s : signed(XLEN-1 downto 0) := (others => '0');
	signal res_v : std_logic_vector(XLEN-1 downto 0) := (others => '0');
begin
	-- Connecting inputs
	op1_u <= unsigned(op1);
	op2_u <= unsigned(op2);

	op1_s <= signed(op1);
	op2_s <= signed(op2);

	-- Connecting outputs
	res <= res_v                 when opsel(2) = '1' else	-- Logic operation
	     std_logic_vector(res_u) when opsel(0) = '1' else	-- SLTU
	     std_logic_vector(res_s);				-- All others

	-- ALU arithmetic operators
	process (op1_s, op2_s, op1_u, op2_u, opsel, ctrl)
	begin
		res_u <= (others => '0');
		res_s <= (others => '0');

		case opsel(1 downto 0) is
			when "00" => -- ADD/SUB
				if (ctrl = '0') then
					res_s <= op1_s + op2_s;
				else
					res_s <= op1_s - op2_s;
				end if;

			when "10" => -- SLT
				if (op1_s < op2_s) then
					res_s(0) <= '1';
				end if;

			when "11" => -- SLTU
				if (op1_u < op2_u) then
					res_u(0) <= '1';
				end if;

			when others => -- irrelevant, not managed by ALU
				res_u <= (others => '0');
				res_v <= (others => '0');

		end case;
	end process;

	-- ALU logic operators
	process (op1, op2, opsel, ctrl)
	begin
		case opsel(1 downto 0) is
			when "00" => -- XOR
				res_v <= op1 xor op2;
			when "10" => -- OR
				res_v <= op1 or op2;
			when "11" => -- AND
				res_v <= op1 and op2;
			when others => -- irrelevant, not managed by ALU
				res_v <= (others => '0');

		end case;
	end process;

end architecture ; -- beh
