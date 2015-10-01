
file(GLOB HEADERS "src/*.h")

add_library(secp256k1 ext.c include/secp256k1.h include/ext.h ${HEADERS})
target_compile_definitions(secp256k1 INTERFACE ETH_HAVE_SECP256K1 PRIVATE HAVE_CONFIG_H)
target_include_directories(secp256k1 PUBLIC .)
target_include_directories(secp256k1 PUBLIC src)

if (NOT MSVC)
	eth_use(secp256k1 REQUIRED Gmp)
	set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -W -std=c89 -pedantic -Wall -Wextra -Wcast-align -Wnested-externs -Wshadow -Wstrict-prototypes -Wno-unused-function -Wno-long-long -Wno-overlength-strings")
endif()
