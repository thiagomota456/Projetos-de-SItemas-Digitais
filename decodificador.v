module decodificador(A, B, C, D, a, b, c, d, e, f, g);
input A, B, C, D, HAB;
output a, b, c, d, e, f, g;

assign a = ~(A + C + (B^D));
assign b = ~((~B) + ((~C)^D));
assign c = ~(B + (~C) + D);
assign d = ~(((~B)&(~D)) + ((C)&(~D)) + (B &(~C)&(D)) + ((~B)&(C)) + A);
assign e = ~(((~B)&(~D)) + ((C)&(~D)));
assign f = ~(A + ((~C)&(~D)) + ((B)&(~C)) + ((B)&(~D)));
assign g = ~(A + (B^C) + ((C)&(~D)));


always @(1)
		begin
		case(A, B, C, D)
			4'b0000
			4'b0001
			4'b0010
			4'b0011
			4'b0100
			4'b0101
			4'b0110
			4'b0111
			4'b1000
			4'b1001
		endcase;
end