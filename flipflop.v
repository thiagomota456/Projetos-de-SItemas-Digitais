module flipflop(J, K, clock, reset, preset, Q);

	input J, K, clock, reset, preset;
	output Q;
	
	
	reg Q = 1'b0;
	
	
always @(posedge clock or posedge reset or posedge preset)
	
	begin
		if(reset == 1)
			begin
				Q = 1'b0;
			end
		else if(preset == 1) 
			begin
				Q = 1'b1;
			end
		else
			begin
				case({J,K})
					2'b0_0 : Q = Q;
					2'b0_1 : Q = 1'b0;
					2'b1_0 : Q = 1'b1;
					2'b1_1 : Q = ~Q;
				endcase
			end
	end


endmodule
