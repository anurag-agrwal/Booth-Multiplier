// Unsigned N-bit Booth Multiplier

module Booth (A, in2, Mul);

parameter N = 4;
input [N-1:0] A, in2;
output [2*N-1:0] Mul;

wire [N+1:-1] B;
wire [2*N-1:0] sgn_A, sgn_A_1, sgn_2A, sgn_2A_1;
reg [2*N-1:0] p [N/2:0];
reg [2*N-1:0] p_shifted [N/2:0];
wire [2*N-1:0] S [N/2-1:0];

integer j,k;

assign B[N-1:0] = in2;
assign {B[N+1], B[N], B[-1]} = {3'b0};

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


assign sgn_A = {{N{1'b0}}, A};					// sign extended A

assign sgn_2A = {sgn_A[2*N-2:0], 1'b0};		// 2A

assign sgn_A_1 = ~sgn_A + 1'b1;					// -A

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







// Signed N-bit Booth


//module Booth (A, in2, Mul);
//
//parameter N = 4;
//input [N-1:0] A, in2;
//output [2*N-1:0] Mul;
//
//wire [N+1:-1] B;
//wire [2*N-1:0] sgn_A, sgn_A_1, sgn_2A, sgn_2A_1;
//reg [2*N-1:0] p [N/2:0];
//reg [2*N-1:0] p_shifted [N/2:0];
//wire [2*N-1:0] S [N/2-1:0];
//
//integer j,k;
//
//assign B[N-1:0] = in2;
//assign {B[N+1], B[N], B[-1]} = {{2{B[N-1]}}, 1'b0};
//
//always @(*) begin
//	for(j=0;j<=N/2;j=j+1) begin
//		
//		case({B[2*j+1], B[2*j], B[2*j-1]})
//			0,7: p[j] = 0;
//			1,2: p[j] = sgn_A;
//			5,6: p[j] = sgn_A_1;
//			3  : p[j] = sgn_2A;
//			4  : p[j] = sgn_2A_1;
//			default: p[j] = 0;
//			
//		endcase
//	end
//end
//
//
//assign sgn_A = {{N{A[N-1]}}, A};					// sign extended A
//
//assign sgn_2A = {sgn_A[2*N-2:0], 1'b0};		// 2A
//
//assign sgn_A_1 = ~sgn_A + 1'b1;					// -A
//
//assign sgn_2A_1 = {sgn_A_1[2*N-2:0], 1'b0};	// -2A
//
//
//always@(*) begin
//
//	for(k=0; k<=N/2;k=k+1) begin: block_name
//		
//		p_shifted[k] = (p[k] << (2*k));
//		
//	end
//end
//
//// N-bit RCA
//
//RCA R1 (p_shifted[0], p_shifted[1], 1'b0, S[0]);
//
//genvar r1;
//generate
//	for(r1=2; r1<=N/2; r1=r1+1) begin: RC
//		
//		RCA R0 (S[r1-2], p_shifted[r1], 1'b0, S[r1-1]);
//		
//	end
//endgenerate
//
//assign Mul = S[N/2-1];
//
//endmodule
















// BEHAVIORAL MODELLING

//module Booth (A, in2, Mul);
//
//parameter N = 5;
//input [N-1:0] A, in2;
//output reg [2*N-1:0] Mul;
//
//wire [N+1:-1] B;
//wire [2*N-1:0] sgn_A, sgn_A_1, sgn_2A, sgn_2A_1;
//reg [2*N-1:0] p [N/2:0];
//reg [2*N-1:0] p_shifted [N/2:0];
//wire [2*N-1:0] M, M1, S;
//
//integer j,k;
//
//assign B[N-1:0] = in2;
//assign {B[N+1], B[N], B[-1]} = 3'b0;
//
//always @(*) begin
//	for(j=0;j<=N/2;j=j+1) begin
//		
//		case({B[2*j+1], B[2*j], B[2*j-1]})
//			0,7: p[j] = 0;
//			1,2: p[j] = sgn_A;
//			5,6: p[j] = sgn_A_1;
//			3  : p[j] = sgn_2A;
//			4  : p[j] = sgn_2A_1;
//			default: p[j] = 0;
//			
//		endcase
//	end
//end
//
//
//assign sgn_A = {{N{A[N-1]}}, A};					// sign extended A
//
//assign sgn_2A = {sgn_A[2*N-2:0], 1'b0};		// 2A
//
//assign sgn_A_1 = ~sgn_A + 1'b1;					// -A
//
//assign sgn_2A_1 = {sgn_A_1[2*N-2:0], 1'b0};	// -2A
//
//
//always@(*) begin
//		Mul=0;
//	for(k=0; k<=N/2;k=k+1) begin: block_name
//		
//		Mul = Mul + (p[k] << (2*k));
////		p_shifted[k] = (p[k] << (2*k));
//	end
//end
//
//
//
//// Shifter in temp
//
//// N- bit RCA
//
////RCA R1 (p_shifted[0], p_shifted[1], 1'b0, S[0]);
////genvar r1;
////generate
////	for(r1=2; r1<=N/2; r1=r1+1) begin: RC
////		RCA R0 (S[r1-2], p_shifted[r1], 1'b0, S[r1-1]);
////		
////	end
////endgenerate
////
////assign Mul = S[N/2-1];
//// Multiple Instantiation
//
//endmodule
