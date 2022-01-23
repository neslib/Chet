/// [static] const AType AName = <Expression>;
const int CINT_CONSTANT = 42;
const float CFLOAT_CONSTANT1 = 3.14;
const double CFLOAT_CONSTANT2 = .14;
const long double CFLOAT_CONSTANT3 = 3.14f;
const char * CSTRING_CONSTANT = "foo";
const unsigned int CHEX_CONSTANT1 = 0x1234;
static const unsigned long CHEX_CONSTANT2 = 0X4321;
const unsigned CSHL_CONSTANT = CINT_CONSTANT<<2;
static const unsigned short CSHR_CONSTANT = 5>>2;
const int CCOMPLEX_CONSTANT = ((((CINT_CONSTANT<<2)+CINT_CONSTANT) | 0xFE) & 255);
const static TInt MyInt = 1234 / 33;
typedef char * TCharPtr;
static const TCharPtr MyString = "Hello World";
const unsigned char * MyString2 = "Hello " 
                                  "World 2";
