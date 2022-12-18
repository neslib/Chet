/// Simple struct
struct Struct1 {
    /// Comment for value
    int value;
};

/// Struct with alias of the same name
struct Struct2 {
    int value; ///< Comment for value
} Struct2;

/// Struct with alias with different name
struct Struct3 {
    /// Constant array of simple type
    char CharArray[10];
    
    /// Constant array of pointer to simple type
    char* PCharArray[10];
} Struct3Alias;

/// Struct with pointer alias of same name
struct Struct4 {
    int value;
} *PStruct4;

/// Typedef struct with alias of same name
typedef struct Struct5 {
    int value;
} Struct5;

/// Typedef struct with alias with different name
typedef struct Struct6 {
    int value;
} Struct6Alias;

/// Struct with pointer alias of same name and pointer alias of different name
typedef struct Struct7 {
    int value;
} Struct7, *PStruct7, *PStruct7Alias;

/// Typedef const struct with alias with different name
typedef const struct Struct8 {
    int value;
} Struct8Alias;

/// Typedef struct with const alias with different name
typedef struct Struct9 {
    int value;
} const Struct9Alias;

/// Typedef struct with field of type pointer to this struct
typedef struct Struct10 {
    struct Struct10* next;
} Struct10Alias, *PStruct10;

/// Typedef struct without name
typedef struct {
    int value;
} Struct11;

/// Bit-backed struct
typedef struct tag_Struct12 {
    unsigned   f1    :16;
    unsigned   f2     :1;
    unsigned   f3     :1;
    unsigned   f4     :1;
    unsigned   f5     :1;
    unsigned   f6     :1;
    unsigned   f7     :1;
    unsigned   f8     :1;
    unsigned   f9     :1;
    unsigned   f10    :1;
    unsigned   f11    :1;
    unsigned   f12    :6;  
} Struct12;

/// Bit-backed struct2
typedef struct tag_Struct13 {
    unsigned short    f1_1     :5;
    unsigned short    f1_2     :1;  
    unsigned short    f1_3     :1;
    unsigned short    f1_4     :1;
    unsigned short    f1_5     :1;
    unsigned short    f1_6     :1;
    unsigned short    f1_7     :1;
    unsigned short    f1_8     :1;
    unsigned short    f1_9     :1;
    unsigned short    f1_10    :1;
    unsigned short    f1_11    :2;
    /// Bit-backed struct2    
    Struct12 f2;    
} Struct13;

/// Bit-backed struct3
typedef struct tag_Struct14 {
    unsigned short    f1_1     :10; 
    unsigned short    f1_2     :1;  
    unsigned short    f1_3     :1;  
    unsigned short    f1_4     :1;  
    unsigned short    f1_5     :1;  
    unsigned short    f1_6     :1;  
    unsigned short    f1_7     :1;     
    Struct12 f2;  /// Bit-backed struct 
    Struct13 f3;  /// Bit-backed struct2        
} Struct14;