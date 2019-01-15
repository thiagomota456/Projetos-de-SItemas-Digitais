module chrono(SW,clock_50, HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);//(HEX0,SW,clock_50);
	input [17:0] SW; 
  	input clock_50; // cristal de freq = 50x10^6 Hz
	
	output [0:6] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
   

	// variaveis intermediárias
	wire  [4:0]horas;
	wire  [5:0]minutos;
	wire  [5:0]segundos;
	
 	wire novo_clock, clk_min, clk_seg;
   wire reset;
	
	wire [5:0] hora_unid,  hora_dez;
   wire [5:0] min_unid,  min_dez;
   wire [4:0] seg_unid,  seg_dez;

	
// chave para RESETAR
	assign reset = SW[10];	
	
// divisor da frequencia de 50MHz para   /(2^ )
	divisor (novo_clock,reset,clock_50);

// contador de segundos
	contador_59(novo_clock,reset,segundos,clk_seg);

// contador de minutos
	contador_59(clk_seg,reset,minutos,clk_min);

// contador de horas
	contador_23(clk_min,rst,horas);


//assign horas = saida_hora;
//assign minutos = saida_min;
//assign segundos = saida_seg;


   assign seg_unid = segundos % 10;
	assign seg_dez = segundos / 10;

	assign min_unid = minutos % 10;
	assign min_dez = minutos / 10;

   assign hora_unid = horas % 10;
	assign hora_dez = horas / 10;



	bcd  H2 (seg_unid[3:0],HEX2[0:6]);
	bcd  H3 (seg_dez[3:0],HEX3[0:6]);
	  
	bcd  H4 (min_unid[3:0],HEX4[0:6]);
	bcd  H5 (min_dez[3:0],HEX5[0:6]);

	bcd  H6 (hora_unid[3:0],HEX6[0:6]);
	bcd  H7 (hora_dez[3:0],HEX7[0:6]);

   bcd  H0 (4'b1111,HEX0[0:6]);
	bcd  H1 (4'b1111,HEX1[0:6]);
endmodule
//-----------------------------------------------------//-----------------------------------------------------

module divisor(novo_clock,reset,clock_50);
	input reset;
	input clock_50;

	output novo_clock;
	reg [25:0]Q;
	wire clk;

	assign clk = clock_50;

	initial begin
		Q = 26'b000;
	end

	always @ (posedge clk or posedge reset) begin
		if (reset == 1'b1) begin
			Q = 26'b000;
		end
		else begin
			Q = Q + 1;
			//if(Q == 16000000) begin
				//Q = 26'b000;
			//end
		end
	end

	assign novo_clock = Q[15]; // novo_clock = 50M/2^24   =   3Hz

endmodule

//-----------------------------------------------------//-----------------------------------------------------

module contador_59(clock,reset,saida59,clk_proximo);

	input clock,reset;

	output reg [5:0]saida59;
	output reg clk_proximo;

	initial 
		begin
			saida59 = 6'b000000;
			clk_proximo <= 1'b1;
		end


	always@ (posedge clock or posedge reset) begin 
		 if(reset == 1)
		  begin
			  saida59 <= 6'b0000000;
		  end
		else
		  if( saida59 ==6'b111011)
			begin
			  saida59 <= 6'b0000000;
			  clk_proximo <= 1'b1;
			end
		else 
			begin
			  saida59 <= saida59 + 1;
			  clk_proximo <= 1'b0;  
			end  
		end
endmodule

//-----------------------------------------------------//-----------------------------------------------------

module contador_23(clock,reset,saida23,clk_proximo);

	input clock,reset;

	output reg [4:0]saida23;
	output reg clk_proximo;

	initial 
		begin
			saida23 = 5'b00000;
			clk_proximo <= 1'b1;
		end


	always@ (posedge clock or posedge reset) begin 
		 if(reset == 1)
		  begin
			  saida23 <= 5'b000000;
		  end
		else
		  if( saida23 ==5'b10111)
			begin
			  saida23 <= 5'b000000;
			  clk_proximo <= 1'b1;
			end
		else 
			begin
			  saida23 <= saida23 + 1;
			  clk_proximo <= 1'b0;  
			end  
		end
endmodule

//-----------------------------------------------------//-----------------------------------------------------

module bcd(ABCD, out);

	input [3:0]ABCD;
	output reg [0:6]out;
	 
	always@(*) begin	
		case (ABCD) // 
		
			4'b0000:	out = 7'b0000001;
			4'b0001:	out = 7'b1001111;
			4'b0010:	out = 7'b0010010;
			4'b0011:	out = 7'b0000110;
			4'b0100:	out = 7'b1001100;
			4'b0101:	out = 7'b0100100;
			4'b0110:	out = 7'b0100000;
			4'b0111:	out = 7'b0001111;
			4'b1000: out = 7'b0000000;
			4'b1001: out = 7'b0000100;

			default:	out = 7'b1111111;
		endcase
	end

endmodule
//-----------------------------------------------------//-----------------------------------------------------