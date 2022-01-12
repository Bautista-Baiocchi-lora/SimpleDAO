// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../../interfaces/IProposal.sol";

contract Proposal is IProposal, Ownable {
    address private sDAO_Contract;
    uint128 public MIN_STAKE = 100;

    bytes32 public title;
    string public info;
    mapping(uint8 => IProposal.VoteOption) public options;
    address public author;

    modifier holdsSufficientStake() {
        require(ERC20(sDAO_Contract).balanceOf(msg.sender) >= MIN_STAKE, string(abi.encodePacked("Proposal::You must hold a minimum of ", MIN_STAKE)));
        _;
    }

    constructor(
        address _sDAO_Contract
    ) Ownable() {
        sDAO_Contract = _sDAO_Contract;
        author = msg.sender;
    }

    function setMetadata(
        bytes32 _title,
        string calldata _info
    ) external onlyOwner{
        require(_title[0] != 0, "Proposal::Title can't be empty.");
        title = _title;
        info = _info;
    }

    function setOptions(
        bytes32[] calldata optionTitles
    ) external onlyOwner {
        require(optionTitles.length > 1, "Proposal::At least 2 options required.");
        
        IProposal.VoteOption[] memory _options = new IProposal.VoteOption[](optionTitles.length);
        for(uint8 i = 0; i < optionTitles.length; i++){
            require(optionTitles[i] != 0, "Proposal::Option can't be an empty string");
            _options[i] = IProposal.VoteOption({id: i, title: optionTitles[i]});
        }

        //options = _options;
        //todo: replace options with new options
    }

    function getVoteOption(uint8 id) view public returns(IProposal.VoteOption memory) {
        require(options[id] != 0, "Proposal::Option doesn't exist");
        return options[id];
    }

    
}