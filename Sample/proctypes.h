#ifndef cdecl_apicall
#define _APICALL      __stdcall
#else
 #define _APICALL     __cdecl
#endif

/// Procedural type without parameters or result
typedef void (*SimpleProc)();

/// Procedural type with single parameter but no result
typedef void (*ProcSingleParam)(int SomeParam);

/// Procedural type with two parameters and result
typedef int (*ProcTwoParams)(int SomeParam, float OtherParam);

/// Procedural type with two unnamed parameters
typedef int (*ProcUnnamedParams)(int, float);

/// Procedural type with single unnamed parameter
typedef int (*ProcSingleUnnamedParam)(int SomeParam, float);

/// Procedural type with other unnamed parameter
typedef int (*ProcOtherUnnamedParam)(int, float SomeParam);

/// Procedural type with variable number of arguments
typedef int (*ProcVariableParams)(int SomeParam, ...);

/// Procedural type without star
typedef int _APICALL (ProcNoStar)(int SomeParam); 