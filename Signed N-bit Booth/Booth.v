// Signed N-bit Booth Multiplier

// NOTE: The difference between N-bit unsigned and signed is just in sign extension
// To make this code Unsigned Booth, just chnage
// 1. {B[N+1], B[N]} to {2{1'b0}}
// 2. sgn_A from {{N{A[N-1]}}, A} to {{N{1'b0}}, A}

module Booth (A, in2, Mul);

parameter N = 8;
input [N-1:0] A, in2;
output [2*N-1:0] Mul;

wire [N+1:-1] B;
wire [2*N-1:0] sgn_A, sgn_A_1, sgn_2A, sgn_2A_1;
reg [2*N-1:0] p [N/2:0];
reg [2*N-1:0] p_shifted [N/2:0];
wire [2*N-1:0] S [N/2-1:0];

integer j,k;

assign B[N-1:0] = in2;
assign {B[N+1], B[N], B[-1]} = {{2{B[N-1]}}, 1'b0};

always @(*) begin
	for(j=0;j<=N/2;j=j+1) begin
		
		case({B[2*j+1], B[2*j], B[2*j-1]})
			0,7: p[j] = 0;
			1,2: p[j] = sgn_A;
			5,6: p[j] = sgn_A_1;
			3  : p[j] = sgn_2A;
			4  : p[j] = sgn_2A_1;
			default: p[j] = 0;
			
		endcase
	end
end


assign sgn_A = {{N{A[N-1]}}, A};			// sign extended A

assign sgn_2A = {sgn_A[2*N-2:0], 1'b0};		// 2A

assign sgn_A_1 = ~sgn_A + 1'b1;				// -A

assign sgn_2A_1 = {sgn_A_1[2*N-2:0], 1'b0};	// -2A


always@(*) begin

	for(k=0; k<=N/2;k=k+1) begin: block_name
		
		p_shifted[k] = (p[k] << (2*k));
		
	end
end

// N-bit RCA

RCA R1 (p_shifted[0], p_shifted[1], 1'b0, S[0]);

genvar r1;
generate
	for(r1=2; r1<=N/2; r1=r1+1) begin: RC
		
		RCA R0 (S[r1-2], p_shifted[r1], 1'b0, S[r1-1]);
		
	end
endgenerate

assign Mul = S[N/2-1];

endmodule



// N-bit Ripple Carry Adder

module RCA (A, B, Cin, Sum);

parameter N = 16;	// NOTE: this N is twice the above N

input [N-1:0] A, B;
input Cin;
output [N-1:0] Sum;

wire [N:0] C;

assign C[0] = Cin;

genvar g1;
generate
	for(g1=0;g1<N;g1=g1+1) begin: Full_Adder
		FA F0 (A[g1], B[g1], C[g1], Sum[g1], C[g1+1]);
	end
endgenerate

endmodule


// Full_Adder

module FA(A, B, Cin, Sum, Cout);
input A, B, Cin;
output Sum, Cout;

assign Sum = A ^ B ^ Cin;
assign Cout = ((A ^ B) & Cin) | (A & B);

endmodule
