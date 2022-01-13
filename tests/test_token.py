import pytest

from brownie import sDAO, accounts, reverts

@pytest.fixture
def admin(accounts):
    return accounts[0]

@pytest.fixture
def mock_user(accounts):
    return accounts[1]

@pytest.fixture
def token(sDAO, admin):
    return admin.deploy(sDAO)

def test_minting_approved(token, admin, mock_user):
    from_a = {"from": admin}

    token.mint(mock_user.address, 1000, from_a)

    assert token.balanceOf(mock_user.address) == 1000

def test_minting_rejected(token, mock_user):
    from_a = {"from": mock_user}

    with reverts():
        token.mint(mock_user, 1000, from_a)

    assert token.balanceOf(mock_user) == 0


def test_burning_approved(token, admin):
    from_a = {"from": admin}

    token.mint(admin.address, 1000, from_a)
    token.burn(admin.address, 1000, from_a)

    assert token.balanceOf(admin.address) == 0

def test_burning_rejected(token, admin, mock_user):
    from_a = {"from": admin}
    from_mock = {"from": mock_user}

    token.mint(mock_user.address, 1000, from_a)

    with reverts():
        token.burn(mock_user.address, 1000, from_mock)

    assert token.balanceOf(mock_user.address) == 1000