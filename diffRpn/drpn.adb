
with mathtypes;
with ada.strings;
with ada.strings.fixed;
with ada.characters.handling;  use ada.characters.handling;
with ada.characters.latin_1;
with ada.numerics;

with text_io; use text_io;



procedure drpn is 

	use mathtypes;

	package math renames mathtypes.math_lib;
	use math;


	procedure myassert( 
		condition : boolean;  
		flag: integer:=0;
		msg: string := ""
		) is
	begin
	  if condition=false then
			put("ASSERTION Failed!  ");
			if flag /= 0 then
				put( "@ " & integer'image(flag) &" : " );
			end if;
			put_line(msg);
			new_line;
			raise program_error;
	  end if;
	end myassert;






--single'model_epsilon=1.2e-7 (accuracy of transcendentals)
small : constant real := real'model_epsilon;

uround: real := small; --set actual later


	--onepi : constant real := arctan(1.0)*4.0;

	-- to ignore errors in pi, minimize them:
	onepi : constant := ada.numerics.pi;

	deg2rad : constant real := onepi/180.0;

	rad2deg : constant real := 180.0/onepi;

	package myreal_io is new text_io.float_io(real);


	type optype is 
	(data,  -- indicator of numerical, non-operator token
	 plus, minus, times, divide, power, asin, acos,
	 sin, cos, tan, ln, aTan, Exp, sqRt, recip
	 );

	type tokentype is 
		record 
			op: optype; 
			tval: real;
			dval: real;
		end record;

	maxstack : integer := 99;
	type stacktype is array(0..maxstack) of tokentype;
	stack : stacktype;
	top : integer := 0; -- next available position

	--global numerical accumulators:
	num, dnum : real := 0.0;
	degmode : boolean := false;



	savtop, savnex : real := 0.0;
	ch,ch2: character;
	last: natural;
	instr: string(1..80);

	subtype linerange is integer range 1..80; --0..79;
	type linetype is array(linerange) of character;
	inchars : linetype;
	len,this  : linerange := 1;

	uistring : string(linerange);

	mem : array(0..9) of real := (others=>0.0);
	memd : array(0..9) of real := (others=>0.0);


function sqr(x:real) return real is
begin
	return x*x;
end sqr;

-- assemble a number when ready:
procedure update( inStr: string ) is
--also update res, dnum, if necessary:
	last: positive;
begin

	if inStr'last>0 then
	--convert inStr to num:
	myreal_io.get(inStr,num,last);
	end if;

	dnum:=uround*abs(num); --error estimate

end update;

procedure showstack is
begin
	put("Stack: ");
	new_line;
	--for i in reverse 1..top loop
	for i in 1..top loop
		myreal_io.put( stack(i-1).tval, 2,11,3 );
		if i=top then
			put_line("    [ stack.top:"&integer'image(top)&" ]");
		else
			new_line;
		end if;
	end loop;
	--new_line;
end showstack;

procedure showline is -- assumes num, dnum, top defined
	toosmall : constant real := 1.0e-1;
	toolarge : constant real := 1.0e4;
	den: real := abs(dnum);

	nstr: string(1..20);
	l,d,x,a,b: natural;
begin
	if den<1.0 then
		den:=1.0;
	end if;

	if(abs(num)<toosmall)or(abs(num)>toolarge) then
	--myreal_io.put(num,5,11,3);
	myreal_io.put(nstr,num,12,3);
	else
	--myreal_io.put(num,9,11,0);
	myreal_io.put(nstr,num,12,0);
	end if;
	--put(nstr); --normal output

-- alternate output in groups of 3:
	l:=nstr'length;
	d:=ada.strings.fixed.index(nstr,".",1);
	x:=ada.strings.fixed.index(nstr,"E",1);
	a:=1; b:=d+3;
	put(nstr(a..b));
	loop
		a:=b+1;
		b:=b+3; 
		if b>l then b:=l; end if;
		if x>1 and b>=x then b:=x-1; end if;
		put("_"); put(nstr(a..b));
		exit when b>=l;
		exit when x>1 and then b>=x-1;
	end loop;
	if x>1 then
		put(nstr(x..l));
	end if;



	put("   Er"); --29jan19
	myreal_io.put(abs(dnum),2,2,3);

	if abs(num)>1.0 then
	put("   Rer"); --29jan19
	myreal_io.put(abs(dnum/den),2,2,3);
	end if;

	put_line("    [ stack.top:"&integer'image(top)&" ]");

end showline;

procedure push( op: optype; inputStr: string := "" ) is
begin

	if( op = data ) and (inputStr'length>=1) then

		update(inputStr);  -- num & dnum are now finalized
		--NOTE that dnum might be negative @ this point

	end if;

	if( top < maxstack ) then
		stack(top).op := op;
		stack(top).tval := num;
		stack(top).dval := abs(dnum); --in case dnum<0
		top := top+1; --points to next available space

		if( op = data ) then
			showline;
		else 
			-- this operator will immediately act on stack
			-- and push the result...

			put(" "&optype'image(op)&" ");
			new_line;

		end if;

	end if;

end push;


--function pop return real is
procedure pop ( v,d : out real ) is
begin
	if( top=0 ) then
	put_line("error: popping empty stack");
	--get_line(instr,last);
	--put_line("aborting");
	--raise program_error;
	else
	top:=top-1;
	end if;

	if( stack(top).op /= data ) then
	put_line("error in pop val");
	get_line(instr,last);
	put_line("aborting");
	raise program_error;
	end if;

	--return stack(top).tval;
	v:=stack(top).tval;
	d:=stack(top).dval;

end pop;


function pop return optype is
begin
	if( top=0 ) then
		put_line("error in pop op: popping empty stack");
		get_line(instr,last);
		put_line("aborting");
		raise program_error;
	end if;
	top:=top-1;
	if( stack(top).op = data ) then
		put_line("error in pop op");
		get_line(instr,last);
		put_line("aborting");
		raise program_error;
	end if;
	return stack(top).op;
end pop;



procedure applyOp is
left, right, ddrr,ddll : real;
op : optype;
nint, ninv : integer;
integral, oddinv, intinv, odd : boolean;
begin
op := pop;
pop(right,ddrr);

case op is
when plus =>
	pop(left, ddll);
	num:=left+right;

-- total differential 
--dnum:=(ddll+ddrr)*abs(num); --WRONG!

	-- 7feb19
	dnum:=ddll+ddrr;

	push( data );

when minus =>
	pop(left, ddll);
	num:=left-right;

-- total differential 
	--dnum:=(ddll+ddrr)*abs(num);WRONG

	--7feb19
	dnum:=ddll+ddrr;

	push( data );

when times =>
	pop(left, ddll);
	num:=left*right;

-- total differential Ok
dnum := abs(right)*ddll+abs(left)*ddrr; --product rule

	push( data );

when divide =>  -- F=l/r: dF=(dl*r-dr*l) /r/r

	if abs(right)<uround then
		put_line("tiny denominator...Divide Aborted");
		showstack;
	else
		pop(left, ddll);
		num:=left/right;

	-- total differential QuotientRule
	--dnum := (ddll*right-ddrr*left)/right/right;
	--dnum := (ddll+ddrr)*abs(right-left)/right/right;

	--7feb19
	dnum := ( ddll*abs(right)+ddrr*abs(left) ) /right/right;

		push( data );

	end if;

when power => -- F=l**r:  dF=F*[ln(l)*dr+r/l*dl]
	pop(left, ddll);

	-- this next maneuver allows [real] results
	-- even with a negative base, so long
	-- as the exponent is an integer or
	-- the reciprocal of an odd number.
	nint := integer( real'rounding(right) );
	integral := ( right = real(nint) );
	ninv := integer( real'rounding(1.0/right) );
	intinv := ( 1.0 / right = real(ninv) );
	odd := (ninv mod 2 = 1);
	oddinv := odd and intinv;

	if integral then
		num:=left**nint;
	elsif oddinv and (left<0.0) then
		num := -( (-left)**right );
	else -- mainstream case:
		num:=left**right;
	end if;

-- total differential 
dnum := num* ( log(left)*ddrr + abs(right/left)*ddll );
--differential for power lf^rt

	push( data );




	--all the rest only require 1 argument...

when sqrt =>
	num:=sqrt(right);
	dnum:=ddrr/2.0/num; -- differential for SQRT

	push( data );

when sin =>
	if degmode then right:=right*deg2rad; end if;
	num:=sin(right);
	dnum:=ddrr*abs(cos(right)); --differential for SIN
	push( data );

when cos =>
	if degmode then right:=right*deg2rad; end if;
	num:=cos(right);
	dnum:=ddrr*abs(sin(right)); --differential for COS
	push( data );

when tan =>
	if degmode then right:=right*deg2rad; end if;
	num:=tan(right);
	dnum:=ddrr/cos(right)/cos(right); --differential for TAN
	push( data );


-- DELETED asin/acos/log2

when atan =>
	num:=arctan(right);
	if degmode then num:=rad2deg*num; end if;
	dnum:=ddrr/(1.0+sqr(right)); --differential for ARCTAN
	push( data );

when asin =>
	num:=arcsin(right);
	if degmode then num:=rad2deg*num; end if;
	dnum:= ddrr/sqrt(1.0-sqr(right));
	push( data);

when acos =>
	num:=arccos(right);
	if degmode then num:=rad2deg*num; end if;
	dnum:= -ddrr/sqrt(1.0-sqr(right));
	push( data);


when exp =>
	num:=exp(right);
	dnum:=ddrr*num; --differential for EXP
	push( data );

when ln =>
	num:=log(right);
	dnum:=ddrr/abs(right); --differential for LOG
	push( data );


when others =>
	put_line("error in applyOp");
	get_line(instr,last);
	put_line("aborting");
	raise program_error;
end case;


exception
	when ada.numerics.argument_error =>
		put_line("argument_error...try again");
		case op is
		when plus | minus | times | divide | power =>
			num:=left; dnum:=ddll; push(data);
			num:=right; dnum:=ddrr; push(data);
		when others=>
			num:=right; dnum:=ddrr; push(data);
		end case;

end applyOp;


procedure get_token( inch: in out linetype; len: in out linerange ) is
ch,ch2: character;
ord : positive_count;
stop : boolean := false;
bch: character := Ada.Characters.Latin_1.BS;
dch: character := Ada.Characters.Latin_1.DEL;
begin

len:=1;
loop
	get_immediate(ch); --gets keybd input as typed
	ord := character'pos(ch);

	if(ord=127)or(ord=8) then -- <del> or <bs>
		if(len>1) then
		len:=len-1;
		put(bch);
		end if;
	else

	inch(len):=ch;
	if(ord/=13)and(ord/=10)and(ord/=27) then
		put( ch );
		if ch='n' then new_line; end if;
	end if;
	stop := (ch in 'A'..'Z')or(ch in 'a'..'z')
		or(ord=43)or(ord=45) -- + -
		or(ord=42)or(ord=47) -- * /
		or(ord=94)           -- ^
		or(ord=27)           -- <esc>
		or(ord=10)or(ord=13); --<ret>

	if len>1 and ch='e' then 
		stop:=false; -- part of a number
	end if;
	if len>1 and ch='-' then
		stop:=false; -- part of a number
	end if;

	if( (ch = 'm') or (ch = 'M') ) then
		-- still need to get memory # 0..9
		get_immediate(ch2);
		put(ch2);
		len:=len+1;
		inch(len):=ch2;
	end if;

	exit when stop;
	len:=len+1;

	end if;

end loop;

if
(ord=10)or(ord=13)or(ord=43)or(ord=45)or
(ord=42)or(ord=47)or(ord=94)or
(ch in 'A'..'Z') or 
((ch in 'a'..'z') and (ch /= 'n') )
then
	new_line;
end if;


end get_token;



procedure menu is
begin
new_line;
put_line("---------------- Differential RPN calculator ---------------");
new_line;
put_line("Key Map:");
put_line("             <z>=>{clr}      <n>=>{CHS}      <k>=>{stack}");
put_line("             <x>=>{X:Y}      <m>=>{STO}      <M>=>{RCL}");

put_line("             <p>=>{pi}       <E>=>{e^x}      <^>=>{x^y}");
put_line("             <s>=>{sin}      <c>=>{cos}      <t>=>{tan}");

put_line("             <S>=>{asin}     <C>=>{acos}     <T>=>{atan}");

put_line("             <D>=>{Deg}      <R>=>{Rad}*");
put_line("             <l>=>{ln}       <r>=>{sqrt}    <esc>=>{quit} ");
new_line;
end menu;

procedure setmacheps(ur: out real) is
	me: real := 1.0;
begin
	loop
		exit when 1.0+0.5*me = 1.0;
		me:=0.5*me;
	end loop;
	ur:=me;
end;

nuval: integer;
ddt,ddn: real;

begin --drpn(main)

setmacheps(uround);

menu;

outer:
loop

get_token(inchars, len);
this:=1;

uistring := string(inchars);

inner: 
loop

	ch := inchars(this);

	if( is_digit(ch) ) then
		nuval:=character'pos(ch) - character'pos('0');
	end if;

	case ch is

		when '+' =>

			if len<=1 then
				push( plus );
				applyOp;
			end if;

		when '-' =>

			if len<=1 then
				push( minus );
				applyOp;
			end if;

		when '*' =>
			push( times );
			applyOp;

		when '/' =>
			push( divide );
			applyOp;

		when '^' =>
			push( power );
			applyOp;

		when 'r' =>
			push( sqrt );
			applyOp;

		when 's' =>
			push( sin );
			applyOp;

		when 'c' =>
			push( cos );
			applyOp;

		when 't' =>
			push( tan );
			applyOp;


		when 'T' =>
			push( atan );
			applyOp;

		when 'S' =>
			push( asin );
			applyOp;

		when 'C' =>
			push( acos );
			applyOp;

		when 'E' =>
			push( exp );
			applyOp;

		when 'l' =>
			push( ln );
			applyOp;




		when 'p' => --pi
			num:=onepi; --arctan(1.0)*4.0;
			dnum:=uround*abs(num);
			push( data );


		when 'n' => -- change sign (Negate)

				pop(num,dnum); --added 31jan19
				num:=-1.0*num;
				push(data);



		when 'q'|'Q' =>  -- quit
			exit outer; --loop (quit gracefully)

		when 'D' => -- deg
			degmode:=true;
			put_line(" Degree mode");

		when 'R' => -- rad
			degmode:=false;
			put_line(" Radian mode");

		when 'x' => -- x:y
			pop(savtop, ddt);
			pop(savnex, ddn);
			num:=savtop; dnum:=ddt; push(data);
			num:=savnex; dnum:=ddn; push(data);

		when 'z' => -- clear
			top:=0;
			put_line(" Clear All");

		when 'm' =>  -- STO logic
			this:=this+1;
			ch2:=inchars(this);
			if( is_digit(ch2) and (top>0) ) then
				nuval:=character'pos(ch2) - character'pos('0');
				pop(savtop,ddt);
				mem(nuval):=savtop;
				memd(nuval):=ddt;
				put     (" stored Memory # "&integer'image(nuval));
				put_line("    [ stack.top:"&integer'image(top)&" ]");
			else
				put(inchars(1));
				put_line(" STO failed");
			end if;

		when 'M' =>  -- RCL logic
			this:=this+1;
			ch2:=inchars(this);
			if( is_digit(ch2) ) then
				nuval:=character'pos(ch2) - character'pos('0');
				num:=mem(nuval); 
				dnum:=memd(nuval);
				push(data);
			else
				put(inchars(1));
				put_line(" RCL failed");
			end if;


		when 'h' => 
			menu;
			showline;

		when 'k' =>
			showstack;

		when '0'..'9' => null;
		when '.' | 'e' => null;


		when others =>

--put("Character entered: "&ch);
--put(", ch'pos: "&integer'image(character'pos(ch)));
--new_line;

			if
			( character'pos(ch) = 13 ) or
			( character'pos(ch) = 10 ) -- unix/linux <enter>
			then -- <enter>

				push( data, uistring(1..len) );

			elsif( character'pos(ch) = 27 ) then --<esc> => exit
				exit outer; --loop (quit program gracefully)

			else -- quit

				put("  unhandled character: |"); put(ch); put("|");
				put_line("showing Menu:");
				--put_line( "char'pos="&integer'image( character'pos(ch) ) );
				menu;

			end if;

	end case;

	exit inner when (this=len);
	this:=this+1;

end loop inner;

end loop outer;

end drpn;

