/// [static] const AType AName = <Expression>;
const int TYPED_INT_CONSTANT = 42;
const float TYPED_FLOAT_CONSTANT1 = 3.14;
const double TYPED_FLOAT_CONSTANT2 = .14;
const long double TYPED_FLOAT_CONSTANT3 = 3.14f;
const char * TYPED_STRING_CONSTANT = "foo";
const unsigned int TYPED_HEX_CONSTANT1 = 0x1234;
static const unsigned long TYPED_HEX_CONSTANT2 = 0X4321;
//const unsigned TYPED_SHL_CONSTANT = TYPED_INT_CONSTANT<<2;
static const unsigned short TYPED_SHR_CONSTANT = 5>>2;
//const int TYPED_COMPLEX_CONSTANT = ((((TYPED_INT_CONSTANT<<2)+TYPED_INT_CONSTANT) | 0xFE) & 255);
const static TInt MyInt = 1234 / 33;
typedef char * TCharPtr;
static const TCharPtr MyString = "Hello World";
//const unsigned char * MyString2 = "Hello " 
//                                  "World 2";
