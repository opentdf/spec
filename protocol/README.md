# Protocol

## Authenticating into the TDF3 System
1. The user enters his or her credentials into the client to establish their identity. 
2. The client presents these credentials to an EAS.  
3. The EAS verifies the credentials, either with its own internal methods or via a federated authentication service.
4) The EAS constructs a bearer token with an expiration time and returns it to the client.

![authenticating](https://files.readme.io/b922c3e-Authenticate_into_TDF_system.png "Authenticating")

_Authenticate into TDF system_

## Create at TDF Service
1. Obtain or create a public/private key pair for the Entity client.
2. Send a GET /kas_public_key request to the KAS.  No authentication is required as the key is public. 
3. Instantiate an instance of the TDF class.  
4. Load the Entity public and private keys into the TDF service.  These may be brand new or re-used from another session. 
5. Load the KAS public key into the TDF service. 
6. If the default settings (e.g. encryption algorithm) are not sufficient configure them with method calls.

![creating](https://files.readme.io/2a1b426-Create_a_TDF3_service.png "Create a service")

_Create a TDF3 service_

## Write a TDF File
1.  Create a [PolicyObject](../format/PolicyObject.md) by specifying the [attributes](../format/AttributeObject.md) and dissemination list  
2. Bundle any data the policy plugins might need into a metadata object. This metadata might include authentication credentials for external services, logging instructions, or any other information needed by the policy updating plugins for this use case installed in the KAS. The form of the metadata object is plugin specific. 
3. Load the policy and metadata into the TDF service.
4. Call one of the "write" methods on the TDF service with the data to be secured.  
5. The TDF service first generates a symmetric encryption key for the data and metadata. 
6. It then generates an HMAC binding of the key so the KAS can check the validity of the key 
7. The TDF service encrypts the metadata object, if any, with the payload encryption key
8. The TDF service creates a zip file, encrypts the data, and loads the ciphertext into the zip as payload files.  If the data is large or streaming it also creates a list of the cryptographic hashes for verification purposes.   
9. Wrap (encrypt) the payload encryption key generated in step (5) with the KAS public key.  Discard the plaintext version of the payload encryption key. 
10. Assemble the [TDF manifest](../format/manifest-json.md) and load it into the zip file.
11. Return the zip file as the TDF file (rename it with the tag .tdf)

![writing](https://files.readme.io/f1e780e-Write_no_splits.png "Write a TDF file")

_Write a TDF file_

## Obtain an Entity Object
1. Bob's client sends an HTTP POST request with its Entity Public Key.   
2. The EAS verifies Bob's bearer token.  If it doesn't check out the transaction ends and Bob doesn't get his EntityObject. 
3. The EAS then fetches Bob's attribute data from its secure database.  
4. The EAS then signs this data with its private key and sends it back to Bob's client.  

![getentity](https://files.readme.io/315a61d-Get_EO.png "Get an entity object")

_Obtaining an entity object_

## Read a File
1. Bob's client provides the TDF3 file to an already configured TDF service.
2. The TDF service constructs an JWT auth_token signed by its Entity private key to prove that it is the same client that requested the EntityObject from the EAS. 
3. The TDF service unpacks the TDF File's manifest and constructs the body of a re-wrap request to the KAS.  The required fields in this object are policy, entity,  wrapped_key, auth_token, and binding.  It may also contain a metadata field.
4. The TDF service requests a key rewrap from the KAS with a HTTP POST using the body generated in step 3.   
5. The first step in the KAS is to use the EAS's public key to verify that the EntityObject is valid. If it checks out then the KAS trusts the EntityObject.  If not, then it terminates the rewrap process and returns a 4XX "not authorized" error.
6. The KAS then uses its private key to unwrap the payload encryption key.  It performs an HMAC validation on this key with the policy string and binding.  If it passes then the key has not been tampered with; if it fails, then the KAS denies the request with a 4xx response.
7. The KAS uses the encryption key to decode the encrypted metadata, if any. 
8. Next, the policy update plugins are called in the order they were installed.  Each takes the latest policy object, a copy of the metadata object, and the entity object, and returns an updated policy object. If a plugin returns a None instead of the updated policy object that signals to the KAS that the policy is no longer valid and the KAS rejects the request with a 4xx response.
9. Equipped with a valid EntityObject and PolicyObject, the KAS decides if the Entity can access the data.  Its decision is based on two criteria:
- does the Entity possess all the Attribute values needed to satisfy the Policy attribute requirements
- is the entity on the policy dissem list?  (if the dissem list is empty this last step is skipped; an empty list is interpreted as a wildcard access)  
10. If the decision is a yes, then the payload encryption key is re-wrapped with the Entity public key and sent back to the client.  If not, then the rewrap is denied with a 4xx response. 
11. The client unwraps the payload encryption key with its Entity private key.
12. The client uses the specified decryption algorithm to decrypt the payload data. 

![reading](https://files.readme.io/e66022f-Read_no_splits.png "Read a file")

_Reading a file_
