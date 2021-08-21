`timescale 1ns/1ps
module testbench();

parameter N = 4;
reg [N-1:0] A, B;
wire [2*N-1:0] Mul;
reg [2*N-1:0] expected;
Booth dut_instance (A, B, Mul);


// Unsigned Booth Testbench
integer i;
initial begin
	for (i=0;i<2**(2*N);i=i+1)
		begin
		
			{A,B} = i;
			expected = A*B;
			#10;
			if(Mul !== expected)
				begin
					$display("Wrong Multiplication of %d and %d is %d, %d", A, B, Mul, expected);
					$stop;
										
				end
		end
end



//initial begin
//
//	for (i=0; i<2**(2*N+1); i=i+1)
//		begin
//			{A, B} = i;		
//			#10;
//			
//	//		if(A >= 2**(N-1) || B >= 2**(N-1))
//			if(A[N-1] ^ B[N-1])
//				begin
//				
//					if(A[N-1])
//						begin
//						expected = B*({2*N{1'b1}} - A);
//							if(Mul !== ({2*N{1'b1}} - A)*B) 
//								begin
//									$display("Wrong Multiplication of %d and %d is %d", A, B, Mul, expected);
//								//	$stop;
//									
//								end
//						end
//					
//					else
//						begin
//						expected = A*({2*N{1'b1}} - B);
//							if(Mul !== A*({2*N{1'b1}} - B)) 
//								begin
//									$display("Wrong Multiplication of %d and %d is %d, %d", A, B, Mul,expected);
//								//	$stop;
//									
//								end
//						end
//				end
//			
//			else
//				begin
//				expected = A*B;
//
//				if(Mul !== A*B) 
//						begin
//							$display("Wrong Multiplication of %d and %d, %d, %d", A, B, Mul, expected);
//							$stop;
//							
//						end
//				end
//		end
//end





endmodule
