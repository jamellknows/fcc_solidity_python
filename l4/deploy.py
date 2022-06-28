import json 

from web3 import Web3


from solcx import compile_standard, install_solc

import os

from dotenv import load_dotenv

load_dotenv()


with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    
    print("Installing...")
    install_solc("0.6.0")
    
    
    #solidity source code
    compiled_sol=compile_standard(
        {
            "language" : "Solidity",
            "sources" : {"SimpleStorage.sol": {"content": simple_storage_file}},
            "settings": {
                "outputSelection": {
                    
                "*": {
                    
                "*" : ["abi", "metadata", "evm.bytecode", "evm.bytecode.sourceMap"]
                }
                
                }
            }
        },
        solc_version="0.6.0",
    )
    
    with open("compiled_code.json", "w") as file:
        json.dump(compiled_sol, file)
        
        #get the bytecode
        
        bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["simpleStorage"]["evm"]["bytecode"]["object"]
        
        #getabi 
        abi = json.loads(compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["metadata"]["output"]["abi"])
        
        #for connecting to ganache
        w3 = Web3(Web3.HTTPProvider("http://0.0.00:8545"))
        chain_id=1337
        my_address = 
        private_key = 
        
        #create the contract in Python 
        
        SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
        
        nonce = w3.eth.getTransaction(my_address)
        transaction = SimpleStorage.constructor().buildTransaction({
            
            "chainId": chain_id,
            "gasPrice": w3.eth.gas_price,
            "from": my_address,
            "nonce": nonce
        })
        
        
        #sign the transaction
        
        signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
        print("Deploying Contract")
        
        #send it
        tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
        print("Waiting for transaction to finish...")
        tx_reciept = w3.eth.wait_for_transaction_receipt(tx_hash)
        
        print(f"Done! Contract deployed to {tx_reciept.contractAddress}")
        
        #working with deployed contracts
        
        simple_storage = w3.eth.contract(address=tx_reciept.contractAddress, abi=abi)
        print(f"Initial Sotred Value {simple_storage.functions.etrieve().call()}")
        greeting_transaction = simple_storage.functions.store(15).buildTransaction({
            "chainId": chain_id,
            "gasPrice": w3.eth.gas_price,
            "from": my_address,
            "nonce": nonce + 1,
        })
        
        
        signed_greeting_txn = w3.eth.account.sign_transaction(
            greeting_transaction, private_key=private_key
        )
        
        tx_greeting_hash = w3.rth.send_raw_transaction(signed_greeting_txn.rawTransaction)
        print("Updating stored value...")
        tx_reciept = w3.eth.wait_for_transaction_receipt(tx_greeting_hash)
        print(simple_storage.functions.retireve().call())