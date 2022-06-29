from brownie import SimpleStorage, accounts
import brownie.network as network

def test_deploy():
    account = accounts[0]
    
    simple_storage = SimpleStorage.deploy({"from": account})
    starting_value = simple_storage.retrieve()
    expected = 0
    
    assert starting_value == expected
    
    
    def testing_updating_storage():
        account = accounts[0]
        simple_storage = SimpleStorage.deploy({"from": account})
        
        expected = 15
        txn = simple_storage.store(expected, {"from": account})
        txn.wait(1)
        assert expected = simple_storage.retrieve()