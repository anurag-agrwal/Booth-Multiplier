`timescale 1ns/1ps
module testbench();

parameter N = 8;
reg [N-1:0] A, B;
wire [2*N-1:0] Mul;

reg [2*N-1:0] expected;

Booth dut_instance (A, B, Mul);

integer i;
initial begin
	for (i=0;i<=101;i=i+1)
		begin
		
			A <= $random %256;
			B <= $random %256;
			#10;
			expected = A*B;
			
			if(Mul !== expected)
				begin
					$display("Wrong Multiplication of %d and %d is %d, %d", A, B, Mul, expected);
					$stop;
										
				end
		end


//	for (i=0;i<=2**(2*N);i=i+1)
//		begin
//		
//			{A,B} = i;
//			expected = A*B;
//			#10;
//			if(Mul !== expected)
//				begin
//					$display("Wrong Multiplication of %d and %d is %d, %d", A, B, Mul, expected);
//					$stop;
//										
//				end
//		end
end

endmodule
