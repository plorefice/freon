-- Design:
--	Dual-port input, single-port output register file for the Freon core.
--
-- Authors:
--	Pietro Lorefice <pietro.lorefice@gmail.com>

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg_file is
	generic (
		XLEN	: integer := 32;	-- # data bits
		ALEN	: integer := 5		-- # address bits (log2(#regs))
	);
	port (
		clk, arst		: in std_logic;
		w_en			: in std_logic;
		w_addr			: in std_logic_vector(ALEN-1 downto 0);
		w_data			: in std_logic_vector(XLEN-1 downto 0);
		r_addr_1, r_addr_2	: in std_logic_vector(ALEN-1 downto 0);
		r_data_1, r_data_2	: out std_logic_vector(XLEN-1 downto 0)
	);
end entity; -- reg_file

architecture beh of reg_file is
	-- Type for the register file itself (array of registers)
	type reg_file_type is array (integer range 2**ALEN-1 downto 0) of
		std_logic_vector(XLEN-1 downto 0);

	signal array_reg : reg_file_type;
begin
	-- hard-wire r0 to zero
	--array_reg(0) <= (others => '0');

	-- synchronous process
	process (clk, arst)
		variable idx : integer;
	begin
		if (arst = '1') then
			array_reg <= (others => (others => '0'));
		elsif rising_edge(clk) then
			-- synchronous write
			idx := to_integer(unsigned(w_addr));
			if (w_en = '1' and idx /= 0) then
				array_reg(idx) <= w_data;
			end if;
		end if;
	end process;

	-- asynchronous reads
	r_data_1 <= array_reg(to_integer(unsigned(r_addr_1)));
	r_data_2 <= array_reg(to_integer(unsigned(r_addr_2)));

end architecture; -- beh
