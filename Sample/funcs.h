/// Func without parameters or result
void SimpleFunc();

/// Func with single parameter but no result
void FuncSingleParam(int SomeParam);

/// Func with two parameters and result
int FuncTwoParams(int SomeParam, float OtherParam);

/// Func with two unnamed parameters
int FuncUnnamedParams(int, float);

/// Func with single unnamed parameter
int FuncSingleUnnamedParam(int SomeParam, float);

/// Func with other unnamed parameter
int FuncOtherUnnamedParam(int, float SomeParam);

/// Func with variable number of arguments
int FuncVariableParams(int SomeParam, ...);

/// Func with param of procedural type
int FuncProcTypeParam(void (*fn)(float), void *Data);