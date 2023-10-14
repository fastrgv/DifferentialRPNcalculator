![screenshot](https://github.com/fastrgv/DifferentialRPNcalculator/blob/master/rpn.png)

Calculating cos(pi/3)

Download link:

https://github.com/fastrgv/DifferentialRPNcalculator/releases/download/v1.0.4/drpn14oct23.7z


* On OSX, Keka works well for 7Z files. The command-line for Keka is:
	* /Applications/Keka.app/Contents/MacOS/Keka --cli 7z x (filename.7z)




# Differential RPN Calculator

**ver 1.04 -- 14oct2023**

* Important corrections to input handling.
* Added reciprocal function using the (i)-btn.


**ver 1.03 -- 12oct2023**

* More improvements in input handling.
* Correction to menu.



**ver 1.02 -- 7oct2023**

* Revived Mac OSX support.
* Improved input handling to better allow [bs]-key or [del]-key to correct bad input.

**ver 1.01 -- 15sep2023**

* New delivery as a stand alone app.
* Dropped Mac OSX development



## Brief Description

This is a terminal calculator with a remarkable twist.
It uses symbolic differentiation to provide a numerically 
precise error estimate with each calculated answer.

It mimics the functionality of an HewlettPackard ReversePolishNotation 
[RPN] calculator simply because I like RPN.  But along with your answer, 
you get some measure of its trustworthiness.

Runs on PCs or laptops running Windows, OSX, or Linux. 


## Error Estimates Using Differentials

Symbolic derivatives and differentials are used
to estimate the precision of calculated values.  The
relative precision of inputs are estimated using the
machine unit roundoff.  Internal math functions 
currently use standard C-doubles.  

Unary operators y=F(x) have the differential estimator 
	dy = F'(x) * dx
The derivative thusly relates the functional error to the 
error in the operand x.  Similarly, the total differential 
can be used for binary operators;  
	i.e. for Z=F(x,y)  use dZ = ∂F/∂x * dx + ∂F/∂y * dy. 

The function y = x^2, for example, has an error in y that is 
approximately twice the error in x (neglecting the error
in the exponent).

Thusly, this app uses symbolic derivatives to define 
accurate differentials.  As written, this regimen is 
efficient, and can often provide better estimates than 
numerically-approximated differentials.  Moreover, it
is far simpler to implement and understand than rigorous
interval arithmetic, yet gives similar benefits.






Here is the header that appears on invocation:
	
---------------- Differential RPN calculator ---------------

           BinOp{+-*/} => Y:stack[top-1] (Op) X:stack[top]
Key Map:

             <z>=>{clr}      <n>=>{CHS}      <k>=>{stack}

             <x>=>{X:Y}      <m>=>{STO}      <M>=>{RCL}

             <p>=>{pi}       <E>=>{e^x}      <^>=>{y^x}

             <s>=>{sin}      <c>=>{cos}      <t>=>{tan}

             <S>=>{asin}     <C>=>{acos}     <T>=>{atan}

             <D>=>{Deg}      <R>=>{Rad}*     <l>=>{ln}

             <r>=>{sqrt}     <h>=>{help}     <i>=>{1/x} 

             <L>={lg}        <q>=>{quit}






### Operation

Type numbers and hit (enter) to push each of them onto the RPN stack.  Then a single key defines the desired operation.

RPN means that you enter the numbers first, then define the operation.  A unary operator, like sin, will apply the function to the number at the top of the numeric stack, then push the result back on the stack top.  A binary operator will pop two values off the stack, then perform the operation on them, and push the result back on the stack top.

For those familiar with the HP RPN calculators, the number entry here differs.  To enter scientific notation you simply type the number as you would normally, eg "1.3e5" or "1.3e-6" followed by the (enter)-key.  The (n)-key will negate the value at the stack top. (i.e.: typing "-1.3e-6" is not allowed)

The allowed binary operators are {plus,minus,times,divide,pow}.  These are invoked with the usual keyboard keys (^ is pow).

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
The application's root directory [~/diffRpn/] contains files for deployment on 3 platforms:  1)linux, 2)Windows, 3)OSX, in addition to all the source code.

Unzip the archive.

* On Linux & Windows, 7z [www.7-zip.org] works well for this. The proper command to extract the archive and maintain the directory structure is "7z x filename".

* On OSX, Keka works well. The command-line for Keka works thusly:
	* /Applications/Keka.app/Contents/MacOS/Keka --cli 7z x (filename.7z)

After the archive is unzipped...


Open a commandline terminal, and cd to the install directory.

To initiate, type:

	"drpn.exe"	on Windows
	"drpn_gnu"	on Linux
	"drpn_osx"	on Mac/OSX




--------------------------------------------------------------------------

## Rebuild Instructions

This app should run as delivered, but the tools to rebuild are included, and should be usable if you have an Ada compiler.

**Windows** => wcmp.bat

**Mac/OSX** => ocmp.sh

**GNU/Linux** => gcmp.sh



## TBD

Crashes due to bad input keystrokes are still possible.  Needs to improve.
If you want to help fix these, send me a script so I can reproduce your problem.



=======================================================================
DifferentialRPN is covered by the GNU GPL v3 as indicated in the sources:

 Copyright (C) 2023  fastrgv@gmail.com

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



