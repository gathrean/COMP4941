# In-Class Assignment 4

## Question 1 [1 mark]

Assuming a hacker can do 2^20 decryptions per second and the key size used in a  symmetric cryptographic technique is 40 bits, (a) how long would a brute force attack take? (b) How much longer if the key size is doubled?

### My Answer 1

(a)

```text
Number of possible keys = 2^40
Time = (number of possible keys) / (decryptions per second)
= 2^40/2^20 = 2^20 seconds
= The brute force attack would take 1,048,576 seconds (12 days)
```

(b)

```text
If key size is doubled to 80 bits
Number of possible keys = 2^80
Time = (number of possible keys) / (decryptions per second)
= 2^80/2^20 = 2^60 seconds = 1,152,921,504,606,846,976 seconds
= It would take 13343998895912 DAYS
```

## Question 2 [2 marks]

Consider a server which, when contacted by a client, returns a message containing important instructions.  Incorporate security solution that ensures confidentiality of the message returned by the server to the client.  Also add provisions to prevent replay attack.  Given that the message could be very long, the server should encrypt the message using symmetric cryptography.  However, then you need to ensure that the distribution of the shared key needs to be done confidential/privately (you can ignore the possibility of the Man-In-The-Middle attack for now).  Your security solution shall be such that the exchange should still take no longer than a single request-response exchange between the client and the server.  

### My Answer 2

```text
- Use a combination of symmetric and asymmetric encryption. The client can encrypt a symmetric key using the server's public key, which only the server can decrypt with its private key. This ensures that the symmetric key is securely shared.
- Digital certificates verified by a Certificate Authority (CA) can be used to assure the identity of the server and the client, adding an extra layer of security and trust.
- Using SSL/TLS protocols can secure the entire communication channel between the client and the server. These protocols use a combination of symmetric and asymmetric encryption to ensure confidentiality, integrity, and authentication.
They also include mechanisms to prevent replay attacks, such as sequence numbers and MACs.
```