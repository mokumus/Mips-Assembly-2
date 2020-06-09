/* SPIM S20 MIPS simulator.
	 Execute SPIM syscalls, both in simulator and bare mode.
	 Execute MIPS syscalls in bare mode, when running on MIPS systems.
	 Copyright (c) 1990-2010, James R. Larus.
	 All rights reserved.

	 Redistribution and use in source and binary forms, with or without modification,
	 are permitted provided that the following conditions are met:

	 Redistributions of source code must retain the above copyright notice,
	 this list of conditions and the following disclaimer.

	 Redistributions in binary form must reproduce the above copyright notice,
	 this list of conditions and the following disclaimer in the documentation and/or
	 other materials provided with the distribution.

	 Neither the name of the James R. Larus nor the names of its contributors may be
	 used to endorse or promote products derived from this software without specific
	 prior written permission.

	 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
	 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
	 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
	 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
	 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
	 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
	 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
	 HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
	 LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
	 OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


#ifndef _WIN32
#include <unistd.h>
#endif
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <sys/types.h>
#include <vector>

#ifdef _WIN32
#include <io.h>
#endif

#include "spim.h"
#include "string-stream.h"
#include "inst.h"
#include "reg.h"
#include "mem.h"
#include "sym-tbl.h"
#include "syscall.h"
#include "spim-utils.h"
#include "run.h"
#include "data.h"
#include "parser.h"
#include "scanner.h"


#include <iostream>
using namespace std;

#ifdef _WIN32
/* Windows has an handler that is invoked when an invalid argument is passed to a system
	 call. https://msdn.microsoft.com/en-us/library/a9yf33zb(v=vs.110).aspx

	 All good, except that the handler tries to invoke Watson and then kill spim with an exception.

	 Override the handler to just report an error.
*/

#include <stdio.h>
#include <stdlib.h>
#include <crtdbg.h>

void myInvalidParameterHandler(const wchar_t* expression,
	 const wchar_t* function, 
	 const wchar_t* file, 
	 unsigned int line, 
	 uintptr_t pReserved)
{
	if (function != NULL)
		{
			run_error ("Bad parameter to system call: %s\n", function);
		}
	else
		{
			run_error ("Bad parameter to system call\n");
		}
}

static _invalid_parameter_handler oldHandler;

void windowsParameterHandlingControl(int flag )
{
	static _invalid_parameter_handler oldHandler;
	static _invalid_parameter_handler newHandler = myInvalidParameterHandler;

	if (flag == 0)
		{
			oldHandler = _set_invalid_parameter_handler(newHandler);
			_CrtSetReportMode(_CRT_ASSERT, 0); // Disable the message box for assertions.
		}
	else
		{
			newHandler = _set_invalid_parameter_handler(oldHandler);
			_CrtSetReportMode(_CRT_ASSERT, 1);  // Enable the message box for assertions.
		}
}
#endif


class Process {
private:
	bool _RUNNING;
	int _PID;
	string _NAME;

	mem_addr _SP;
	mem_addr _PC;
	mem_addr _nPC;

	reg_word _HI;
	reg_word _LO;
	reg_word _R[R_LENGTH];
	reg_word _CCR[4][32];
	reg_word _CPR[4][32];

public:
	void setPC(mem_addr vPC){ _PC = vPC;}
	mem_addr getPC(){return _PC;}

	void setRunning(bool vR){ _RUNNING = vR;}
	bool isRunning(){return _RUNNING;}

	string getName(){return _NAME;}


	Process(int pid, string name, mem_addr vPC, mem_addr vSP){
		_PID = pid;
		_NAME = name;
		_PC = vPC;
		_SP = vSP;
		_RUNNING = false;
	}

	void info(){
		printf("PID: %d, NAME: %-20s, PC: 0x%08x, SP: 0x%08x, %s\n", 
			_PID, _NAME.c_str(), _PC, _SP, _RUNNING ? "Running" : "Sleeping");
	}

	void saveState(){
		//printf("Saved PC: 0x%08x\n", PC);
		_PC  = PC;
		_nPC = nPC;
		_HI  = HI;
		_LO  = LO;

		for(int i = 0; i < 4; i++){
			for(int j = 0; j < 32; j++){
				_CCR[i][j] = CCR[i][j];
				_CPR[i][j] = CPR[i][j];

			}
		}

		for(int i = 0; i < R_LENGTH; i++){
			_R[i] = R[i];
		}
	}

	void restoreState(){
		//printf("Restored PC: 0x%08x\n", PC);
		PC  = _PC; 
		nPC = _nPC;
		HI  = _HI;
		LO  = _LO;

		for(int i = 0; i < 4; i++){
			for(int j = 0; j < 32; j++){
				CCR[i][j] = _CCR[i][j];
				CPR[i][j] = _CPR[i][j];
			}
		}

		for(int i = 0; i < R_LENGTH; i++){
			R[i] = _R[i];
		}
	}

};

class ProcessTable {
public:
	vector <Process> table;

	Process& getProcess(int pid){
		return table.at(pid);
	}

	void show(){
		for(unsigned long i = 0; i < table.size(); i++)
			table[i].info();
	}


};

ProcessTable pt;

bool read_assembly_file_no_flush (char *name);
void init(int pid, string name, mem_addr vPC, mem_addr vSP);

int activeProcess = 0;
int num_of_process = 1;
char filename[100];


void context_switch(int old_pid, int new_pid, ProcessTable pt){
	if(old_pid == 0){
		run_spim (pt.getProcess(new_pid).getPC() , 10000000 , false);	
	}
	else{
		pt.getProcess(old_pid).saveState();
		pt.show();
		cout << "========================\n";
		pt.getProcess(new_pid).restoreState();	
		run_spim (pt.getProcess(new_pid).getPC() , 10000000 , false);
	}
}

void SPIM_timerHandler(){
	try{
		int old_pid = activeProcess;
		if(activeProcess == 0 | activeProcess == 3)
			activeProcess = 1;
		else
			activeProcess++;

		cout << "========================\n";
		cout << "TIMER INTERRUPT\n";
 		printf("PC: 0x%08x\n",PC);
 		pt.getProcess(old_pid).setRunning(false);
 		pt.getProcess(activeProcess).setRunning(true);
		//pt.show();
		cout << "Active Process: " << pt.getProcess(activeProcess).getName() << "\n";
		cout << "========================\n";
		context_switch(old_pid, activeProcess, pt);

		//Works only if context switch fails
		throw logic_error( "ContextSwitchFailed\n" );
		
	}
	catch ( exception &e ){
		cout <<  endl << "Caught: " << e.what( ) << endl;
	};
}


bool read_assembly_file_no_flush (char *name){
  	FILE *file = fopen (name, "rt");
  	if (file == NULL){
		error ("Cannot open file: `%s'\n", name);
		return false;
  	}
  	else{
		flush_local_labels (0);
	 	initialize_scanner (file);
	  	initialize_parser (name);
	  	while (!yyparse ()) ;
	 	fclose (file);
	 	end_of_assembly_file ();
	  	return true;
	}  	
}


void init(int pid, string name, mem_addr vPC, mem_addr vSP){
	Process gtuOS(pid,name,vPC,vSP);
	pt.table.push_back(gtuOS);
}


/* Decides which syscall to execute or simulate.  Returns zero upon
	 exit syscall and non-zero to continue execution. */
int
do_syscall ()
{
#ifdef _WIN32
		windowsParameterHandlingControl(0);
#endif

	/* Syscalls for the source-language version of SPIM.  These are easier to
		 use than the real syscall and are portable to non-MIPS operating
		 systems. */

	switch (R[REG_V0]){
		case INIT_OS_SYSCALL:
			init(0,"init",PC+0x30,R[REG_SP]);
			break;

		case INIT_PROCESS_SYSCALL:
			strcpy(filename, (char*)mem_reference (R[REG_A0]));
			read_assembly_file_no_flush(filename);
			init(num_of_process++,(char*)mem_reference (R[REG_A0]),find_symbol_address((char*)mem_reference (R[REG_A1])),R[REG_SP]);
			break;

		case EXECUTE_SYSCALL:
			pt.show();
			break;

		case PRINT_INT_SYSCALL:
			write_output (console_out, "%d", R[REG_A0]);
			break;

		case PRINT_FLOAT_SYSCALL:
			{
	float val = FPR_S (REG_FA0);

	write_output (console_out, "%.8f", val);
	break;
			}

		case PRINT_DOUBLE_SYSCALL:
			write_output (console_out, "%.18g", FPR[REG_FA0 / 2]);
			break;

		case PRINT_STRING_SYSCALL:
			write_output (console_out, "%s", mem_reference (R[REG_A0]));
			break;

		case READ_INT_SYSCALL:
			{
	static char str [256];

	read_input (str, 256);
	R[REG_RES] = atol (str);
	break;
			}

		case READ_FLOAT_SYSCALL:
			{
	static char str [256];

	read_input (str, 256);
	FPR_S (REG_FRES) = (float) atof (str);
	break;
			}

		case READ_DOUBLE_SYSCALL:
			{
	static char str [256];

	read_input (str, 256);
	FPR [REG_FRES] = atof (str);
	break;
			}

		case READ_STRING_SYSCALL:
			{
	read_input ( (char *) mem_reference (R[REG_A0]), R[REG_A1]);
	data_modified = true;
	break;
			}

		case SBRK_SYSCALL:
			{
	mem_addr x = data_top;
	expand_data (R[REG_A0]);
	R[REG_RES] = x;
	data_modified = true;
	break;
			}

		case PRINT_CHARACTER_SYSCALL:
			write_output (console_out, "%c", R[REG_A0]);
			break;

		case READ_CHARACTER_SYSCALL:
			{
	static char str [2];

	read_input (str, 2);
	if (*str == '\0') *str = '\n';      /* makes xspim = spim */
	R[REG_RES] = (long) str[0];
	break;
			}

		case EXIT_SYSCALL:
			spim_return_value = 0;
			return (0);

		case EXIT2_SYSCALL:
			spim_return_value = R[REG_A0];	/* value passed to spim's exit() call */
			return (0);

		case OPEN_SYSCALL:
			{
#ifdef _WIN32
				R[REG_RES] = _open((char*)mem_reference (R[REG_A0]), R[REG_A1], R[REG_A2]);
#else
	R[REG_RES] = open((char*)mem_reference (R[REG_A0]), R[REG_A1], R[REG_A2]);
#endif
	break;
			}

		case READ_SYSCALL:
			{
	/* Test if address is valid */
	(void)mem_reference (R[REG_A1] + R[REG_A2] - 1);
#ifdef _WIN32
	R[REG_RES] = _read(R[REG_A0], mem_reference (R[REG_A1]), R[REG_A2]);
#else
	R[REG_RES] = read(R[REG_A0], mem_reference (R[REG_A1]), R[REG_A2]);
#endif
	data_modified = true;
	break;
			}

		case WRITE_SYSCALL:
			{
	/* Test if address is valid */
	(void)mem_reference (R[REG_A1] + R[REG_A2] - 1);
#ifdef _WIN32
	R[REG_RES] = _write(R[REG_A0], mem_reference (R[REG_A1]), R[REG_A2]);
#else
	R[REG_RES] = write(R[REG_A0], mem_reference (R[REG_A1]), R[REG_A2]);
#endif
	break;
			}

		case CLOSE_SYSCALL:
			{
#ifdef _WIN32
	R[REG_RES] = _close(R[REG_A0]);
#else
	R[REG_RES] = close(R[REG_A0]);
#endif
	break;
			}

		default:
			run_error ("Unknown system call: %d\n", R[REG_V0]);
			break;
		}

#ifdef _WIN32
		windowsParameterHandlingControl(1);
#endif
	return (1);
}


void
handle_exception ()
{
	if (!quiet && CP0_ExCode != ExcCode_Int)
		error ("Exception occurred at PC=0x%08x\n", CP0_EPC);

	exception_occurred = 0;
	PC = EXCEPTION_ADDR;
	switch (CP0_ExCode)
		{
		case ExcCode_Int:
			break;

		case ExcCode_AdEL:
			if (!quiet)
	error ("  Unaligned address in inst/data fetch: 0x%08x\n", CP0_BadVAddr);
			break;

		case ExcCode_AdES:
			if (!quiet)
	error ("  Unaligned address in store: 0x%08x\n", CP0_BadVAddr);
			break;

		case ExcCode_IBE:
			if (!quiet)
	error ("  Bad address in text read: 0x%08x\n", CP0_BadVAddr);
			break;

		case ExcCode_DBE:
			if (!quiet)
	error ("  Bad address in data/stack read: 0x%08x\n", CP0_BadVAddr);
			break;

		case ExcCode_Sys:
			if (!quiet)
	error ("  Error in syscall\n");
			break;

		case ExcCode_Bp:
			exception_occurred = 0;
			return;

		case ExcCode_RI:
			if (!quiet)
	error ("  Reserved instruction execution\n");
			break;

		case ExcCode_CpU:
			if (!quiet)
	error ("  Coprocessor unuable\n");
			break;

		case ExcCode_Ov:
			if (!quiet)
	error ("  Arithmetic overflow\n");
			break;

		case ExcCode_Tr:
			if (!quiet)
	error ("  Trap\n");
			break;

		case ExcCode_FPE:
			if (!quiet)
	error ("  Floating point\n");
			break;

		default:
			if (!quiet)
	error ("Unknown exception: %d\n", CP0_ExCode);
			break;
		}
}
