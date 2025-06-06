#!/usr/bin/env python


from eth_account import Account
import secrets
priv = secrets.token_hex(32)
private_key = "0x" + priv

print ("Private key (do not share):", private_key)

acct = Account.from_key(private_key)
print("Public Address:", acct.address)



