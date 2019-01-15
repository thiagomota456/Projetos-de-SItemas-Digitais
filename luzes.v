module luzes(in, preset, reset, clock_placa, Q3, Q2, Q1, Q0);

	input in, preset, reset, clock_placa;
	
	output reg Q3, Q2, Q1, Q0;
	
	reg [25:0] cont;
	
	initial
		begin
			cont = 26'b0;
		end
	
	always @ (posedge clock_placa)
		begin
			cont = cont + 1;
			if (cont == 26'b10111110101111000010000000)
				begin
					cont = 26'b0;
				end
		end
	
	wire clock;
	assign clock = cont[25];
	
	always @ (posedge clock or posedge reset or posedge preset)
		begin
			if (reset == 1'b1)
				begin
					Q3 <= 1'b0;
					Q2 <= 1'b0;
					Q1 <= 1'b0;
					Q0 <= 1'b0;
				end
			else
			if (preset == 1'b1)
				begin
					Q3 <= 1'b1;
					Q2 <= 1'b1;
					Q1 <= 1'b1;
					Q0 <= 1'b1;
				end
			else
				begin
					Q3 <= in;
					Q2 <= Q3;
					Q1 <= Q2;
					Q0 <= Q1;
				end
		end

endmodule
