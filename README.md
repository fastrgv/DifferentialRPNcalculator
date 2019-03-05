# Differential RPN Calculator

**ver 1.00 -- 5feb19**

## Brief Description

This terminal app runs on PCs or laptops running Windows, OSX or GNU/Linux.  It attempts to mimic the functionality of an HP ReversePolishNotation [RPN] calculator with the added enhancement of an error estimate.  So along with your answer, you get a good idea of its trustworthiness.

## Details

Unary operators y=F(x) have the differential estimator dy = F'(x) * dx.  The derivative thusly relates the functional error to the error in the operand x.  Similarly, the total differential is used for binary operators;  
i.e. for Z=F(x,y) one uses dZ = ∂F/∂x * dx + ∂F/∂y * dy.

The function y = x^2, for example, has an error in y that is approximately twice the error in x.

So this app uses symbolic derivatives to help define accurate differentials.  As written, this regimen is efficient, and can often provide better estimates than numerically-approximated differentials.

As each raw data item is entered, the unit roundoff error defines the initial dx.




Here is the header that appears on invocation:
	
---------------- Differential RPN calculator ---------------

Key Map:

             <z>=>{clr}      <n>=>{CHS}      <k>=>{stack}

             <x>=>{X:Y}      <m>=>{STO}      <M>=>{RCL}

             <p>=>{pi}       <E>=>{e^x}      <^>=>{x^y}

             <s>=>{sin}      <c>=>{cos}      <t>=>{tan}

             <S>=>{asin}     <C>=>{acos}     <T>=>{atan}

             <D>=>{Deg}      <R>=>{Rad}*

             <l>=>{ln}       <r>=>{sqrt}    <esc>=>{quit} 



### Operation

Type numbers and hit (enter) to push each of them onto the RPN stack.  Then a single key defines the desired operation.

RPN means that you enter the numbers first, then define the operation.  A unary operator, like sin, will apply the function to the number at the top of the numeric stack, then push the result back on the stack top.  A binary operator will pop two values off the stack, then perform the operation on them, and push the result back on the stack top.

For those familiar with the HP RPN calculators, the number entry here differs.  To enter scientific notation you simply type the number as you would normally, eg "1.3e5" or "1.3e-6" followed by the (enter)-key.  The (n)-key will negate the value at the stack top.  (ie: typing "-1.3e-6" is not allowed)

The allowed binary operators are {plus,minus,times,divide,pow}.  These are invoked with the usual keyboard keys.

### Memory Function (mk/Mk, k=1..9):

Enter a number, then type m3 + (enter), to store it in memory #3 location.  This will pop it off the stack.

Recall it by typing M3 + (enter);  this puts it on top of stack, while retaining it in memory location #3.

Enhancements to user-friendliness will be coming soon!


### Example output [ ln(1.3e-6) ]:

1.3e-6

1.300_000_000_000_000E-06 .. Er 2.89E-22 .. [ stack.top: 1 ]

l

 LN 
 
-13.553_146_293_496_782 .. Er 2.22E-16 .. Rer 1.64E-17 .. [ stack.top: 1 ]




## Setup & Running:
The application's root directory [~/diffRpn/] contains files for deployment on 3 platforms:  1)OS-X, 2)linux, 3)Windows, in addition to all the source code.

Unzip the archive.

Open a commandline terminal, and cd to the install directory.

To initiate, type:

	"drpn.exe"	on Windows
	"drpn_gnu"	on Linux
	"drpn_osx"	on OSX




--------------------------------------------------------------------------

## Rebuild Instructions

This app should run as delivered, but the tools to rebuild are included, and should be usable if you have an Ada compiler.

**Windows** => wcmp.bat

**MacOSX** => ocmp.sh

**GNU/Linux** => lcmp.sh


=======================================================================
DifferentialRPN is covered by the GNU GPL v3 as indicated in the sources:

 Copyright (C) 2019  fastrgv@gmail.com

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation, either version 3 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You may read the full text of the GNU General Public License
 at <http://www.gnu.org/licenses/>.


