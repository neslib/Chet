#define INT_CONSTANT 42
#define FLOAT_CONSTANT1 3.14
#define FLOAT_CONSTANT2 .14
#define FLOAT_CONSTANT3 3.14f
#define STRING_CONSTANT "foo"
#define HEX_CONSTANT1 0x1234
#define HEX_CONSTANT2 0X4321
#define SHL_CONSTANT INT_CONSTANT<<2
#define SHR_CONSTANT 5>>2
#define COMPLEX_CONSTANT ((((INT_CONSTANT<<2)+INT_CONSTANT) | 0xFE) & 255)
/// todo: a.t - this definition translates incorectly and needs postprocessing
#define BUTTONS_OKA (LPSTR)1 