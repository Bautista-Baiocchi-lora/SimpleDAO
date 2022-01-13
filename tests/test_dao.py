import pytest 

from brownie import sDAO, DAO, Proposal, accounts, reverts
from brownie.convert import to_bytes
from enum import Enum 


class DAOState(Enum):
    FRESH=0
    PROPOSAL=1
    ELECTION=2
    RESULT=3


@pytest.fixture
def admin(accounts):
    return accounts[0]

@pytest.fixture
def mock_user(index, accounts):
    return accounts[index]

@pytest.fixture
def token(admin):
    return admin.deploy(sDAO)

@pytest.fixture
def dao(admin, token):
    return DAO.deploy(token, {"from":admin})

def test_dao_creation(token, dao):
    assert dao.getGovernanceToken() == token
    assert dao.getState() == DAOState.FRESH.value

def test_start_proposal(web3, dao):
    dao.initiateProposal(web3.toHex(text="my title"), "the info")

    assert dao.getState() == DAOState.PROPOSAL.value
    
    proposal = Proposal(dao.getProposal())

    assert proposal is not None 


