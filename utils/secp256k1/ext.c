/*
	This file is part of cpp-ethereum.

	cpp-ethereum is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	cpp-ethereum is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	along with cpp-ethereum.  If not, see <http://www.gnu.org/licenses/>.
*/
/** @file ext.c
 * Ethereum extensions to libecp256k1
 * @authors:
 *   Arkadiy Paronyan <i@gavwood.com>
 * @date 2014
 */

#include "src/secp256k1.c"

int secp256k1_ecdh_raw(const secp256k1_context* ctx, unsigned char *result, const secp256k1_pubkey *point, const unsigned char *scalar)
{
	int ret = 0;
	int overflow = 0;
	secp256k1_gej res;
	secp256k1_ge pt;
	secp256k1_scalar s;
	ARG_CHECK(result != NULL);
	ARG_CHECK(point != NULL);
	ARG_CHECK(scalar != NULL);

	secp256k1_pubkey_load(ctx, &pt, point);
	secp256k1_scalar_set_b32(&s, scalar, &overflow);
	if (overflow || secp256k1_scalar_is_zero(&s))
		ret = 0;
	else
	{
		secp256k1_ecmult_const(&res, &pt, &s);
		secp256k1_ge_set_gej(&pt, &res);
		secp256k1_fe_normalize(&pt.x);
		secp256k1_fe_normalize(&pt.y);
		secp256k1_fe_get_b32(result, &pt.x);
		ret = 1;
	}

	secp256k1_scalar_clear(&s);
	return ret;
}

