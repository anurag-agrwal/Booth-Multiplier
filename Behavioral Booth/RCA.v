module RCA (A, B, Cin, Sum);

parameter N = 8;	// NOTE: this N is twice the above N

input [N-1:0] A, B;
input Cin;
//output Cout;
output [N-1:0] Sum;

wire [N:0] C;

assign C[0] = Cin;

genvar g1;
generate
	for(g1=0;g1<N;g1=g1+1) begin: Full_Adder
		FA F0 (A[g1], B[g1], C[g1], Sum[g1], C[g1+1]);
	end
endgenerate

//assign Cout = C[N];

endmodule


// Full_Adder

module FA(A, B, Cin, Sum, Cout);
input A, B, Cin;
output Sum, Cout;

assign Sum = A ^ B ^ Cin;
assign Cout = ((A ^ B) & Cin) | (A & B);

endmodule
