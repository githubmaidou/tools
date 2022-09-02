from binascii import b2a_hex
import sys
import base64

def sid_to_str(sid):
    try:
        # Python 3
        if str is not bytes:
            # revision
            revision = int(sid[0])
            # count of sub authorities
            sub_authorities = int(sid[1])
            # big endian
            identifier_authority = int.from_bytes(sid[2:8], byteorder='big')
            # If true then it is represented in hex
            if identifier_authority >= 2 ** 32:
                identifier_authority = hex(identifier_authority)

            # loop over the count of small endians
            sub_authority = '-' + '-'.join([str(int.from_bytes(sid[8 + (i * 4): 12 + (i * 4)], byteorder='little')) for i in range(sub_authorities)])
        # Python 2
        else:
            revision = int(b2a_hex(sid[0]))
            sub_authorities = int(b2a_hex(sid[1]))
            identifier_authority = int(b2a_hex(sid[2:8]), 16)
            if identifier_authority >= 2 ** 32:
                identifier_authority = hex(identifier_authority)

            sub_authority = '-' + '-'.join([str(int(b2a_hex(sid[11 + (i * 4): 7 + (i * 4): -1]), 16)) for i in range(sub_authorities)])
        objectSid = 'S-' + str(revision) + '-' + str(identifier_authority) + sub_authority

        return objectSid
    except Exception:
        pass
    return sid
#decode objectSid and AllowedToActOnBehalfOfOtherIdentity in ldapsearch result
sid = base64.b64decode(sys.argv[1])[-28:]
print(sid_to_str(sid))
