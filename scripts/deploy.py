from brownie import sDAO, accounts
from brownie.project import compiler

admin = accounts[0]

mockUser = accounts[1]

def main():
    Token = sDAO.deploy({'from': admin})

    tx = Token.mint(mockUser.address, 1000, {"from": admin})
    tx.info()
    print(mockUser.balance())