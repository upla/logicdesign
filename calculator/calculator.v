module calculator(
      input num1_1, num1_2, num1_3, num2_1, num2_2, num2_3, add, sub, multi, div,
		output hex1_0,	hex1_1, hex1_2, hex1_3, hex1_4, hex1_5, hex1_6,	//hex6
		hex2_0, hex2_1, hex2_2, hex2_3, hex2_4, hex2_5, hex2_6, //hex4
		hex3_0, hex3_1, hex3_2, hex3_3, hex3_4, hex3_5, hex3_6, //hex1
		hex4_0, hex4_1, hex4_2, hex4_3, hex4_4, hex4_5, hex4_6,	//hex0
		uHex1_0, uHex1_1, uHex1_2, uHex1_3,uHex1_4, uHex1_5, uHex1_6, // unused hex hex7
		uHex2_0, uHex2_1, uHex2_2, uHex2_3,uHex2_4, uHex2_5, uHex2_6,	//hex5
		uHex3_0, uHex3_1, uHex3_2, uHex3_3,uHex3_4, uHex3_5, uHex3_6,	//hex3
		uHex4_0, uHex4_1, uHex4_2, uHex4_3,uHex4_4, uHex4_5, uHex4_6	//hex2
   );
   
   wire [2:0] num1, num2;
	wire [5:0] result;
	reg [3:0] ten = 4'b1010;
	
   getNum(num1_1, num1_2, num1_3, num1);
	getNum(num2_1, num2_2, num2_3, num2);
   compute(num1, num2, add, sub, multi, div, result);
	
	printNull(uHex1_0, uHex1_1, uHex1_2, uHex1_3,uHex1_4, uHex1_5, uHex1_6);
	printNull(uHex2_0, uHex2_1, uHex2_2, uHex2_3,uHex2_4, uHex2_5, uHex2_6);
	printNull(uHex3_0, uHex3_1, uHex3_2, uHex3_3,uHex3_4, uHex3_5, uHex3_6);
	printNull(uHex4_0, uHex4_1, uHex4_2, uHex4_3,uHex4_4, uHex4_5, uHex4_6);
	
	print3BitNum(num1, hex1_0, hex1_1, hex1_2, hex1_3, hex1_4, hex1_5, hex1_6);
	
	print3BitNum(num2, hex2_0, hex2_1, hex2_2, hex2_3, hex2_4, hex2_5, hex2_6);
	
	print5BitNum10(result / ten, hex3_0, hex3_1, hex3_2, hex3_3, hex3_4, hex3_5, hex3_6);
	print5BitNum(result % ten , hex4_0, hex4_1, hex4_2, hex4_3, hex4_4, hex4_5, hex4_6);
   
endmodule

module getNum(
   input bit1,
   input bit2,
   input bit3,
   output [2:0] num
   );
	
	assign num[0] = bit3;
	assign num[1] = bit2;
	assign num[2] = bit1;
	
endmodule

module compute(
   input [2:0] num1,         //operand1
   input [2:0] num2,         //operand2
	input add, //operator
	input sub,
	input multi,
	input div,
   output [5:0] result
	);
	
	reg [5:0] tmp;
	reg [5:0] MINUS_ONE = 6'b110011;
	reg [5:0] ZERO = 6'b000000;

	always @ (*)
	begin
		if(add + sub + multi + div == 0)
			tmp <= ZERO;
		else if(add + sub + multi + div == 1)
		begin
			if(add == 1)
				tmp <= num1 + num2;
			else if(sub == 1)
			begin
				if(num1 == num2)
					tmp <= ZERO;
				else if(num1 > num2)
					tmp <= num1 - num2 ; 
				else
					tmp <= (MINUS_ONE - 1) + num2 - num1;
			end
			else if(multi == 1)
				tmp <= num1 * num2;
			else if(div == 1)
			begin
				if(num2 == 0)
					tmp <= MINUS_ONE;
				else 
					tmp <= num1 / num2;
			end
		end
		else
			tmp <= MINUS_ONE;
   end
	
	assign result = tmp;
	
endmodule

module printNull(
	output zero, one, two, three, four, five, six
	);
	
	assign zero = 1;
   assign one = 1;
   assign two = 1;
   assign three = 1;
   assign four = 1;
   assign five = 1;
   assign six = 1;
	
endmodule

module print3BitNum(
	input [2:0] num,
	output zero, one, two, three, four, five, six
	);
	
	assign zero = !(num[1] | (num[0] & num[2]) | (!num[0] & !num[2]));
   assign one = !(!num[2] | (num[0] & num[1]) | (!num[0] & !num[1]));
   assign two = !(num[0] | !num[1] | num[2]);
   assign three = !((!num[0] & !num[2]) | (!num[0] & num[1]) | (num[1] & !num[2]) | (num[0] & !num[1] & num[2]));
   assign four = !((!num[0] & !num[2]) | (!num[0] & num[1]));
   assign five = !((!num[1] & num[2]) | (!num[0] & !num[1]) | (!num[0] & num[2]));
   assign six = !((!num[0] & num[1]) | (!num[1] & num[2]) | (num[1] & !num[2]));
	
endmodule

module print5BitNum10(
   input [4:0] num,
	output zero, one, two, three, four, five, six
	);
      
   assign zero = !((num[1] & !num[3]) | (!num[0] & !num[1] & !num[2]) | (!num[1] & !num[2] & num[3]));
	assign one = !(!num[2] & !num[3] | (!num[0] & !num[1] & !num[3]) | (num[0] & num[1] & !num[3]) | (!num[1] & !num[2] & num[3]));
	assign two = !((!num[1] & !num[2]) | (num[0] & num[1] & !num[3]) | (!num[0] & num[2] & !num[3]));
	assign three = !((!num[0] & num[1] & !num[3]) | (!num[0] & !num[1] & !num[2]) | (num[1] & !num[2] & !num[3]) | (!num[1] & !num[2] & num[3]));
	assign four = !((!num[0] & !num[1] & !num[2]) | (!num[0] & num[1] & !num[3]));
	assign five = !((!num[0] & !num[1] & !num[3]) | (!num[0] & num[2] & !num[3]) | (!num[1] & !num[2] & num[3]));
	assign six = !((!num[0] & num[1] & !num[3]) | (num[1] & !num[2] & !num[3]) | (!num[1] & num[2] & !num[3]) | (!num[1] & !num[2] & num[3]));
      
      
endmodule

module print5BitNum(
	input [4:0] num,
	output zero, one, two, three, four, five, six
	);
   
	assign zero = !((num[1] & !num[3]) | (!num[0] & !num[1] & !num[2]) | (num[0] & num[2] & !num[3]) | (!num[1] & !num[2] & num[3]));
	assign one = !((!num[2] & !num[3]) | (!num[0] & !num[1] & !num[3]) | (num[0] & num[1] & !num[3]) | (!num[1] & !num[2] & num[3]));
	assign two = !((num[2] & !num[3]) | (num[0] & !num[3]) | (!num[0] & !num[1] & !num[2]) | (!num[1] & !num[2] & num[3]));
	assign three = !((!num[0] & num[1] & !num[3]) | (!num[0] & !num[1] & !num[2]) | (num[1] & !num[2] & !num[3]) | (!num[1] & !num[2] & num[3]) | (num[0] & !num[1] & num[2] & !num[3]));
	assign four = !((!num[0] & num[1] & !num[3]) | (!num[0] & !num[1] & !num[2]));
	assign five = !((!num[1] & num[2] & !num[3]) | (!num[0] & !num[1] & !num[3]) | (!num[0] & num[2] & !num[3]) | (!num[1] & !num[2] & num[3]));
	assign six = !((!num[0] & num[1] & !num[3]) | (num[1] & !num[2] & !num[3]) | (!num[1] & num[2] & !num[3])  |  (!num[1] & !num[2] & num[3]));

      
endmodule
