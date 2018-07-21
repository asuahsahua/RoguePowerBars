bitwise_and_table =  {[0]={[0]= 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
		{[0]= 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1},
		{[0]= 0, 0, 2, 2, 0, 0, 2, 2, 0, 0, 2, 2, 0, 0, 2, 2},
		{[0]= 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3},
		{[0]= 0, 0, 0, 0, 4, 4, 4, 4, 0, 0, 0, 0, 4, 4, 4, 4},
		{[0]= 0, 1, 0, 1, 4, 5, 4, 5, 0, 1, 0, 1, 4, 5, 4, 5},
		{[0]= 0, 0, 2, 2, 4, 4, 6, 6, 0, 0, 2, 2, 4, 4, 6, 6},
		{[0]= 0, 1, 2, 3, 4, 5, 6, 7, 0, 1, 2, 3, 4, 5, 6, 7},
		{[0]= 0, 0, 0, 0, 0, 0, 0, 0, 8, 8, 8, 8, 8, 8, 8, 8},
		{[0]= 0, 1, 0, 1, 0, 1, 0, 1, 8, 9, 8, 9, 8, 9, 8, 9},
		{[0]= 0, 0, 2, 2, 0, 0, 2, 2, 8, 8,10,10, 8, 8,10,10},
		{[0]= 0, 1, 2, 3, 0, 1, 2, 3, 8, 9,10,11, 8, 9,10,11},
		{[0]= 0, 0, 0, 0, 4, 4, 4, 4, 8, 8, 8, 8,12,12,12,12},
		{[0]= 0, 1, 0, 1, 4, 5, 4, 5, 8, 9, 8, 9,12,13,12,13},
		{[0]= 0, 0, 2, 2, 4, 4, 6, 6, 8, 8,10,10,12,12,14,14},
		{[0]= 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15}};

bitwise_or_table   = {[0]={[0]= 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15},
		{[0]= 1, 1, 3, 3, 5, 5, 7, 7, 9, 9,11,11,13,13,15,15},
		{[0]= 2, 3, 2, 3, 6, 7, 6, 7,10,11,10,11,14,15,14,15},
		{[0]= 3, 3, 3, 3, 7, 7, 7, 7,11,11,11,11,15,15,15,15},
		{[0]= 4, 5, 6, 7, 4, 5, 6, 7,12,13,14,15,12,13,14,15},
		{[0]= 5, 5, 7, 7, 5, 5, 7, 7,13,13,15,15,13,13,15,15},
		{[0]= 6, 7, 6, 7, 6, 7, 6, 7,14,15,14,15,14,15,14,15},
		{[0]= 7, 7, 7, 7, 7, 7, 7, 7,15,15,15,15,15,15,15,15},
		{[0]= 8, 9,10,11,12,13,14,15, 8, 9,10,11,12,13,14,15},
		{[0]= 9, 9,11,11,13,13,15,15, 9, 9,11,11,13,13,15,15},
		{[0]=10,11,10,11,14,15,14,15,10,11,10,11,14,15,14,15},
		{[0]=11,11,11,11,15,15,15,15,11,11,11,11,15,15,15,15},
		{[0]=12,13,14,15,12,13,14,15,12,13,14,15,12,13,14,15},
		{[0]=13,13,15,15,13,13,15,15,13,13,15,15,13,13,15,15},
		{[0]=14,15,14,15,14,15,14,15,14,15,14,15,14,15,14,15},
		{[0]=15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15}};

bitwise_xor_table   ={[0]={[0]= 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15},
		{[0]= 1, 0, 3, 2, 5, 4, 7, 6, 9, 8,11,10,13,12,15,14},
		{[0]= 2, 3, 0, 1, 6, 7, 4, 5,10,11, 8, 9,14,15,12,13},
		{[0]= 3, 2, 1, 0, 7, 6, 5, 4,11,10, 9, 8,15,14,13,12},
		{[0]= 4, 5, 6, 7, 0, 1, 2, 3,12,13,14,15, 8, 9,10,11},
		{[0]= 5, 4, 7, 6, 1, 0, 3, 2,13,12,15,14, 9, 8,11,10},
		{[0]= 6, 7, 4, 5, 2, 3, 0, 1,14,15,12,13,10,11, 8, 9},
		{[0]= 7, 6, 5, 4, 3, 2, 1, 0,15,14,13,12,11,10, 9, 8},
		{[0]= 8, 9,10,11,12,13,14,15, 0, 1, 2, 3, 4, 5, 6, 7},
		{[0]= 9, 8,11,10,13,12,15,14, 1, 0, 3, 2, 5, 4, 7, 6},
		{[0]=10,11, 8, 9,14,15,12,13, 2, 3, 0, 1, 6, 7, 4, 5},
		{[0]=11,10, 9, 8,15,14,13,12, 3, 2, 1, 0, 7, 6, 5, 4},
		{[0]=12,13,14,15, 8, 9,10,11, 4, 5, 6, 7, 0, 1, 2, 3},
		{[0]=13,12,15,14, 9, 8,11,10, 5, 4, 7, 6, 1, 0, 3, 2},
		{[0]=14,15,12,13,10,11, 8, 9, 6, 7, 4, 5, 2, 3, 0, 1},
		{[0]=15,14,13,12,11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1, 0}};

function Bitwise_tohex ( Bitwise_invalue)
	if ((Bitwise_invalue > 4294967295) or (Bitwise_invalue < 0)) then
		 UI_ERRORMESSAGE("You must use 32 bit unsigned integers");
		return -1;
	end
	Bitwise_return_converted={};
	Bitwise_work=Bitwise_invalue;
	for Bitwise_index = 1, 8 do
		Bitwise_temp=Bitwise_work/16;
		Bitwise_return_converted[Bitwise_index]=16*(Bitwise_temp-floor(Bitwise_temp));
		Bitwise_work=floor(Bitwise_temp);
	end
	return Bitwise_return_converted;
end

function Bitwise_fromhex ( Bitwise_invalue_table)
	Bitwise_work=Bitwise_invalue_table[8];
	for Bitwise_index=7,1,-1 do
		Bitwise_work=Bitwise_work*16;
		Bitwise_work=Bitwise_work+Bitwise_invalue_table[Bitwise_index];
	end
	return Bitwise_work;
end

function Bitwise_and (Bitwise_lvalue, Bitwise_rvalue)
	Bitwise_result={};
	Bitwise_lvalue_c = Bitwise_tohex (Bitwise_lvalue);
	Bitwise_rvalue_c = Bitwise_tohex (Bitwise_rvalue);
	for Bitwise_index=1,8 do
		Bitwise_result[Bitwise_index]=bitwise_and_table[Bitwise_lvalue_c[Bitwise_index]][Bitwise_rvalue_c[Bitwise_index]];
	end
	return Bitwise_fromhex(Bitwise_result);
end

function Bitwise_or (Bitwise_lvalue, Bitwise_rvalue)
	Bitwise_result={};
	Bitwise_lvalue_c = Bitwise_tohex (Bitwise_lvalue);
	Bitwise_rvalue_c = Bitwise_tohex (Bitwise_rvalue);
	for Bitwise_index=1,8 do
		Bitwise_result[Bitwise_index]=bitwise_or_table[Bitwise_lvalue_c[Bitwise_index]][Bitwise_rvalue_c[Bitwise_index]];
	end
	return Bitwise_fromhex(Bitwise_result);
end

function Bitwise_xor (Bitwise_lvalue, Bitwise_rvalue)
	Bitwise_result={};
	Bitwise_lvalue_c = Bitwise_tohex (Bitwise_lvalue);
	Bitwise_rvalue_c = Bitwise_tohex (Bitwise_rvalue);
	for Bitwise_index=1,8 do
		Bitwise_result[Bitwise_index]=bitwise_xor_table[Bitwise_lvalue_c[Bitwise_index]][Bitwise_rvalue_c[Bitwise_index]];
	end
	return Bitwise_fromhex(Bitwise_result);
end

function Bitwise_not (Bitwise_ovalue)
	Bitwise_ovalue=floor(Bitwise_ovalue);
	return 4294967295-Bitwise_ovalue;
end

function Bitwise_shift_left (Bitwise_ovalue)
	Bitwise_ovalue=floor(Bitwise_ovalue);
	Bitwise_ovalue=Bitwise_ovalue*2;
	if (Bitwise_ovalue > 4294967295) then
		Bitwise_ovalue=Bitwise_ovalue-4294967296;
	end
	return Bitwise_ovalue;
end

function Bitwise_shift_right (Bitwise_ovalue)
	Bitwise_ovalue=floor(Bitwise_ovalue);
	if ((Bitwise_ovalue/2) == floor(Bitwise_ovalue/2)) then
		Bitwise_ovalue=Bitwise_ovalue-1;
	end
	Bitwise_ovalue=Bitwise_ovalue/2;
	return Bitwise_ovalue;
end

function Bitwise_rotate_left (Bitwise_ovalue)
	Bitwise_ovalue=floor(Bitwise_ovalue);
	Bitwise_ovalue=Bitwise_ovalue*2;
	if (Bitwise_ovalue > 4294967295) then
		Bitwise_ovalue=Bitwise_ovalue-4294967295;
	end
	return Bitwise_ovalue;
end

function Bitwise_shift_right (Bitwise_ovalue)
	Bitwise_ovalue=floor(Bitwise_ovalue);
	if ((Bitwise_ovalue/2) == floor(Bitwise_ovalue/2)) then
		Bitwise_ovalue=Bitwise_ovalue-1;
		Bitwise_overflow=1;
	else
		Bitwise_overflow=0;
	end
	Bitwise_ovalue=Bitwise_ovalue/2;
	return Bitwise_ovalue+(Bitwise_overflow*4294967296);
end
